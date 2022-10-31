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

    func login(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else {
                completion(FirebaseAuthErrors.errorLogingUser)
                return
            }
            if let error = error {
                completion(error)
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
        completion: @escaping (Error?) -> Void
    ) {
        guard userCredentials.passwordsMatch else {
            completion(FirebaseAuthErrors.passwordsDoNotmatch)
            return
        }
        Auth.auth().createUser(withEmail: userCredentials.email, password: userCredentials.password) { [weak self] result, error in
            guard let self = self else {
                completion(FirebaseAuthErrors.errorRegisteringUser)
                return
            }
            if let error = error {
                completion(error)
                return
            }
            guard let user = result?.user else {
                completion(FirebaseAuthErrors.errorRegisteringUser)
                return
            }

            Task {
                let result = await self.uploadProfileImage(userCredentials.profileImage)
                if let error = result.error {
                    completion(error)
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

                COLLECTION_USERS.document(user.uid).setData(data) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
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
         async -> (url: String, error: Error?) {
            guard let image1 = image,
                  let imageData = image1.jpegData(compressionQuality: 0.3) else {
                return ("", nil)
            }
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child(filename)
            return await withCheckedContinuation { continuation in
                storageRef.putData(imageData) { _, error in
                    if let error = error {
                        continuation.resume(returning: ("", error))
                        return
                    }
                    storageRef.downloadURL { url, error1 in
                        guard let urlString = url?.absoluteString else {
                            continuation.resume(returning: ("", error1))
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

    func fetchUser(completion: @escaping (Error?) -> Void) {
        guard let uid = userSession?.uid else {
            completion(FirebaseAuthErrors.errorFetchingUser)
            return
        }
        COLLECTION_USERS.document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else {
                return
            }
            if let error = error {
                completion(error)
                return
            }
            guard let data = snapshot?.data() else {
                completion(FirebaseAuthErrors.errorFetchingUser)
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
        COLLECTION_USERS.document(uid).updateData(data) { [weak self] error in
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

    func editProfileImage(_ image: UIImage) { //TODO: delete previous image
        guard let uid = userSession?.uid else {
            return
        }
        Task {
            let profileImageUrl = await self.uploadProfileImage(image).url
            let data = [
                "profileImageUrl": profileImageUrl
            ]
            COLLECTION_USERS.document(uid).updateData(data) { [weak self]  _ in
                guard let self = self else {
                    return
                }
                self.user?.profileImageUrl = profileImageUrl
            }
        }
    }

    func reauthenticate(email: String, password: String, completion: @escaping (Error?) -> Void) {
        guard let userSession = userSession else {
            completion(FirebaseAuthErrors.errorReauthUser)
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
                completion(FirebaseAuthErrors.errorReauthUser)
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
        guard let userSession = userSession else {
            completion(FirebaseAuthErrors.errorDeletingUser)
            return
        }
        userSession.delete { [weak self] error in
            guard let self = self else {
                completion(FirebaseAuthErrors.errorDeletingUser)
                return
            }
            if let error = error {
                completion(error)
            } else {
                COLLECTION_USERS.document(userSession.uid).delete { error in
                    if let error = error {
                        completion(error)
                    } else {
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
            completion(FirebaseAuthErrors.errorDeletingImage)
            return
        }
        Storage.storage().reference(forURL: user.profileImageUrl).delete { error in
            completion(error)
        }
    }

    func sendPasswordReset(withEmail email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}
