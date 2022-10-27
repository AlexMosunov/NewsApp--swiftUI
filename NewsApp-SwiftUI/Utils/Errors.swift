//
//  Errors.swift
//  NewsApp-SwiftUI
//
//  Created by User on 25.10.2022.
//

import Foundation

enum FetchingErrors: Error {
    case wrongQuery
}

extension FetchingErrors: LocalizedError {
    private var errorDescription: String {
        switch self {
        case .wrongQuery:
            return NSLocalizedString("No results with for this search, try typing different query", comment: "")
        }
    }
}

enum FirebaseAuthErrors: LocalizedError {
    case errorDeletingUser
    case errorReauthUser
    case errorDeletingImage
    case errorLogingUser
    case errorFetchingUser
    case errorRegisteringUser
    case passwordsDoNotmatch

    private var errorDescription: String {
        switch self {
        case .errorDeletingUser:
            return NSLocalizedString("Error deleting user", comment: "")
        case .errorReauthUser:
            return NSLocalizedString("Error re-authenticating user", comment: "")
        case .errorDeletingImage:
            return NSLocalizedString("Error deleting image", comment: "")
        case .errorLogingUser:
            return NSLocalizedString("Error loging user", comment: "")
        case .errorFetchingUser:
            return NSLocalizedString("Error fetching user", comment: "")
        case .errorRegisteringUser:
            return NSLocalizedString("Error registering user", comment: "")
        case .passwordsDoNotmatch:
            return NSLocalizedString("Password that you entered does not match with the one, entered in `repeat password` field", comment: "")
        }
    }
}
