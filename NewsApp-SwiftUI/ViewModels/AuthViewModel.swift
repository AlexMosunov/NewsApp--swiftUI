//
//  AuthViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.10.2022.
//

import SwiftUI
import Firebase
import FirebaseStorage

//@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var isAuthenticating = false
//    @Published var error: Error?
    @Published var user: User?

    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }

    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: error \(error.localizedDescription)")
                return
            }
            self.userSession = result?.user
            self.fetchUser()
        }
    }

    func registerUser(
        email: String, password: String,
        repeatPassword: String, username: String,
        fullname: String, profileImage: UIImage?
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: error \(error.localizedDescription)") // TODO: show error on UI
                return
            }
            print("DEBUG: Success")
            guard let user = result?.user else {
                return
            }

            Task {
                let profileImageUrl = await self.uploadProfileImage(profileImage).url
                let data = [
                    "email": email,
                    "username": username.lowercased(),
                    "fullname": fullname,
                    "profileImageUrl": profileImageUrl,
                    "uid": user.uid
                ]

                Firestore.firestore().collection("users").document(user.uid).setData(data) { _ in
                    print("DEBUG: Successflully uplaoded data")
                    self.userSession = user
                    self.fetchUser()
                }
            }

        }
    }

    func uploadProfileImage(_ image: UIImage?)
         async -> (url: String, error: String?) {
            guard let image1 = image,
                  let imageData = image1.jpegData(compressionQuality: 0.3) else {
                return ("", "Unable to compress image")
            }
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child(filename)
            return await withCheckedContinuation { continuation in
                storageRef.putData(imageData) { _, error in
                    if let error = error {
                        print("DEBUG: erorr \(error.localizedDescription)")
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
    }

    func fetchUser() {
        guard let uid = userSession?.uid else {
            return
        }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            guard let data = snapshot?.data() else {
                return
            }
            self.user = User(dictionary: data)
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
}
