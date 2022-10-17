//
//  AuthViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.10.2022.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth

struct UserCredentials {
    let email: String
    let password: String
    let repeatPassword: String
    let username: String
    let fullname: String
    let profileImage: UIImage?
    var passwordsMatch: Bool {
        password == repeatPassword
    }
}

class AuthViewModel: ObservableObject {
    @Published var userSession: Firebase.User?
    @Published var isAuthenticating = false
    @Published var error: Error?
    @Published var user: User?

    init() {
        userSession = Auth.auth().currentUser
        fetchUser { _ in }
    }

    func login(withEmail email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: error \(error.localizedDescription)")
                completion(error.localizedDescription)
                return
            }
            self.userSession = result?.user
            self.fetchUser { error in
                if let error = error {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }

    func registerUser(
        _ userCredentials: UserCredentials,
        completion: @escaping (String?) -> Void
    ) {
        guard userCredentials.passwordsMatch else {
            completion("Password that you entered does not match with the one, entered in `repeat password` field")
            return
        }
        Auth.auth().createUser(withEmail: userCredentials.email, password: userCredentials.password) { result, error in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            guard let user = result?.user else {
                completion("Error registering user")
                return
            }

            Task {
                let result = await self.uploadProfileImage(userCredentials.profileImage)
                if let errorString = result.error {
                    completion(errorString)
                    return
                }
                let profileImageUrl = result.url
                let data = [
                    "email": userCredentials.email,
                    "username": userCredentials.username.lowercased(),
                    "fullname": userCredentials.fullname,
                    "profileImageUrl": profileImageUrl,
                    "uid": user.uid
                ]

                Firestore.firestore().collection("users").document(user.uid).setData(data) { error in
                    if let error = error {
                        completion(error.localizedDescription)
                        return
                    }
                    print("DEBUG: Successflully uplaoded data")
                    self.userSession = user
                    self.fetchUser { error in
                        if let error = error {
                            completion(error)
                            return
                        }
                        completion(nil)
                    }
                }
            }

        }
    }

    func uploadProfileImage(_ image: UIImage?)
         async -> (url: String, error: String?) {
            guard let image1 = image,
                  let imageData = image1.jpegData(compressionQuality: 0.3) else {
                return ("", nil)
            }
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child(filename)
            return await withCheckedContinuation { continuation in
                storageRef.putData(imageData) { _, error in
                    if let error = error {
                        continuation.resume(returning: ("", error.localizedDescription))
                        return
                    }
                    storageRef.downloadURL { url, error1 in
                        guard let urlString = url?.absoluteString else {
                            continuation.resume(returning: ("", error1?.localizedDescription))
                            return
                        }
                        continuation.resume(returning: (urlString, nil))
                    }
                }
            }
        }

    func signOut() {
        try? Auth.auth().signOut()
        userSession = nil
        user = nil
    }

    func fetchUser(completion: @escaping (String?) -> Void) {
        guard let uid = userSession?.uid else {
            completion("Error fetching user")
            return
        }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else {
                completion("Error fetching user")
                return
            }
            self.user = User(dictionary: data)
            Constants.userId = self.user?.id
            completion(nil)
        }
    }

    // MARK: UPDATE USER FUNCTIONS
    func updateUserDisplayName(
        textType: SettingsEditTextOption,
        username: String,
        handler: @escaping(_ success: Bool, _ errorMessage: String?) -> Void
    ) {
        guard let uid = userSession?.uid else {
            handler(false, "Unable to fetch user id")
            return
        }

        let data: [String:Any] = [
            textType.rawValue: username.lowercased()
        ]
        Firestore.firestore().collection("users").document(uid).updateData(data) { error in
            if let error = error {
                handler(false, "Error updating \(textType.rawValue). \(error)")
                return
            } else {
                switch textType {
                case .username:
                    self.user?.username = username
                case .bio:
                    self.user?.bio = username
                }
                handler(true, nil)
                return
            }
        }
    }

    func editProfileImage(_ image: UIImage) {
        guard let uid = userSession?.uid else {
            return
        }

        Task {
            let profileImageUrl = await self.uploadProfileImage(image).url
            let data = [
                "profileImageUrl": profileImageUrl
            ]

            Firestore.firestore().collection("users").document(uid).updateData(data) { _ in
                print("DEBUG: Successflully uplaoded image")
                self.user?.profileImageUrl = profileImageUrl
            }
        }
    }

    func deleteUser(completion: @escaping (String?) -> Void) {
        guard let user = user, let userSession = userSession else {
            completion("Error deleting user")
            return
        }
        userSession.delete { error in
            if let error = error {
                completion(error.localizedDescription)
                print("2" + error.localizedDescription)
            } else {
                print("success user deleted")
                Firestore.firestore().collection("users").document(userSession.uid).delete { error in
                    if let error = error {
                        completion(error.localizedDescription)
                        print("1" + error.localizedDescription)
                    } else {
                        print("collection deleted succesfully")
                        Storage.storage().reference(forURL: user.profileImageUrl).delete { error in
                            if let error = error {
                                print("3" + error.localizedDescription)
                            } else {
                                print("image deleted succesfully")
                            }
                        }
                        self.signOut()
                    }
                }
            }
        }
    }
}
