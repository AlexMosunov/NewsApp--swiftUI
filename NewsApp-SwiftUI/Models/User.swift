//
//  User.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.10.2022.
//

import Firebase

struct User: Identifiable {
    let id: String
    var username: String
    let fullname: String
    let email: String
    var profileImageUrl: String
    var bio: String?

    var isCurrentUser: Bool {
        Auth.auth().currentUser?.uid == self.id
    }

    init(dictionary: [String: Any]) {
        self.id = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
    }
}
