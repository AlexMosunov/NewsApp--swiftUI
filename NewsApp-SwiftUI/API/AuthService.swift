//
//  AuthService.swift
//  NewsApp-SwiftUI
//
//  Created by User on 06.10.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static func logUserIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
//        Auth.auth().signIn(withEmail: <#T##String#>, password: <#T##String#>, completion: completion)
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping (Error?) -> Void ) {
        ImageUploader.uploadImage(image: credentials.profileImage) { imageURL in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in

                if let error = error {
                    print("DEBUG: Failed to register user \(error.localizedDescription)")
                    return
                }

                guard let uid = result?.user.uid else { return }

                let data: [String: Any] = ["email" : credentials.email,
                                           "fullname" : credentials.fullname,
                                           "profileImageUrl" : imageURL,
                                           "uid" : uid,
                                           "username" : credentials.username]

                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
}
