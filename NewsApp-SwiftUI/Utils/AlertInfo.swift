//
//  AlertInfo.swift
//  NewsApp-SwiftUI
//
//  Created by User on 27.10.2022.
//

import Foundation

struct AlertInfo: Identifiable {
    enum ProfileAlertType {
        case signOutAlert
        case deleteUserAlert
        case generalError
    }

    let id: ProfileAlertType
    let title: String
    let message: String
}
