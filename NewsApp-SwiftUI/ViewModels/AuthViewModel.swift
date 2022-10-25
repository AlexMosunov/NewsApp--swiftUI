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
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else {
                return
            }
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
        Auth.auth().createUser(withEmail: userCredentials.email, password: userCredentials.password) { [weak self] result, error in
            guard let self = self else {
                return
            }
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
        print("DEBUG: signed out")
        userSession = nil
        user = nil
    }

    func fetchUser(completion: @escaping (String?) -> Void) {
        guard let uid = userSession?.uid else {
            completion("Error fetching user")
            return
        }
        Firestore.firestore().collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else {
                return
            }
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
        Firestore.firestore().collection("users").document(uid).updateData(data) { [weak self] error in
            guard let self = self else {
                return
            }
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

            Firestore.firestore().collection("users").document(uid).updateData(data) { [weak self]  _ in
                guard let self = self else {
                    return
                }
                self.user?.profileImageUrl = profileImageUrl
            }
        }
    }

    func reauthenticate(email: String, password: String, completion: @escaping (Error?) -> Void) {
        guard let userSession = userSession else {
            completion(FirebaseErrors.errorReauthUser)
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        userSession.reauthenticate(with: credential) { _, error in
            completion(error)
        }
    }

    func reauthenticateAndDelete(email: String, password: String, completion: @escaping (Error?) -> Void) {
        reauthenticate(email: email, password: password) { [weak self]  error in
            guard let self = self else {
                completion(FirebaseErrors.errorReauthUser)
                return
            }
            if let error = error {
                completion(error)
                return
            }
            self.deleteUser { error in
                completion(error)
            }
        }
    }

    func deleteUser(completion: @escaping (Error?) -> Void) {
        guard let user = user, let userSession = userSession else {
            completion(FirebaseErrors.errorDeletingUser)
            return
        }

        print("DEBUG: is about to delete user")
        userSession.delete { [weak self] error in
            guard let self = self else {
                completion(FirebaseErrors.errorDeletingUser)
                return
            }
            if let error = error {
                completion(error)
            } else {
                print("DEBUG: success user deleted")
                Firestore.firestore().collection("users").document(userSession.uid).delete { error in
                    if let error = error {
                        completion(error)
                    } else {
                        print("DEBUG: collection deleted succesfully")
                        self.deleteUserImage { error in
                            self.signOut()
                            completion(error)
                        }
                    }
                }
            }
        }
    }

    func deleteUserImage(completion: @escaping (Error?) -> Void) {
        guard let user = user, !user.profileImageUrl.isEmpty else {
            completion(FirebaseErrors.errorDeletingImage)
            return
        }
        Storage.storage().reference(forURL: user.profileImageUrl).delete { error in
            completion(error)
        }
    }
}
