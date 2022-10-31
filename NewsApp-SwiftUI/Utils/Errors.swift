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
    var errorDescription: String? {
        switch self {
        case .wrongQuery:
            return NSLocalizedString(
                ErrorMessagesLocalised.wrongQuery.rawValue,
                comment: ""
            )
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

    var errorDescription: String? {
        switch self {
        case .errorDeletingUser:
            return NSLocalizedString(ErrorMessagesLocalised.errorDeletingUser.rawValue, comment: "")
        case .errorReauthUser:
            return NSLocalizedString(ErrorMessagesLocalised.errorReauthUser.rawValue, comment: "")
        case .errorDeletingImage:
            return NSLocalizedString(ErrorMessagesLocalised.errorDeletingImage.rawValue, comment: "")
        case .errorLogingUser:
            return NSLocalizedString(ErrorMessagesLocalised.errorLogingUser.rawValue, comment: "")
        case .errorFetchingUser:
            return NSLocalizedString(ErrorMessagesLocalised.errorFetchingUser.rawValue, comment: "")
        case .errorRegisteringUser:
            return NSLocalizedString(ErrorMessagesLocalised.errorRegisteringUser.rawValue, comment: "")
        case .passwordsDoNotmatch:
            return NSLocalizedString(ErrorMessagesLocalised.passwordsDoNotmatch.rawValue, comment: "")
        }
    }
}
