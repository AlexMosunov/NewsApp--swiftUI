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

enum FirebaseErrors: LocalizedError {
    case errorDeletingUser
    case errorReauthUser
    case errorDeletingImage

    private var errorDescription: String {
        switch self {
        case .errorDeletingUser:
            return NSLocalizedString("Error deleting user", comment: "")
        case .errorReauthUser:
            return NSLocalizedString("Error re-authenticating user", comment: "")
        case .errorDeletingImage:
            return NSLocalizedString("Error deleting image", comment: "")
        }
    }
}
