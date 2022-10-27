//
//  AuthTextFieldViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by User on 27.10.2022.
//

import SwiftUI

enum RegistrationTextFieldType: Int, Hashable, CaseIterable {
    case email
    case fullname
    case username
    case password
    case repeatPassword
}

enum LoginTextFieldType: Int, Hashable, CaseIterable {
    case email
    case password
}

struct AuthTextFieldViewModel {

    let type: RegistrationTextFieldType
    var shouldValidate = true

    var secureEntry: Bool {
        switch type {
        case .password:
            return true
        case .repeatPassword:
            return true
        default:
            return false
        }
    }

    var placeholder: String {
        switch type {
        case .email:
            return "Email Address"
        case .username:
            return "Username"
        case .fullname:
            return "Fullname"
        case .password:
            return "Password"
        case .repeatPassword:
            return "Repeat Password"
        }
    }

    var imageName: String {
        switch type {
        case .email:
            return "envelope.fill"
        case .username:
            return "person.crop.rectangle"
        case .fullname:
            return "person.crop.rectangle"
        case .password:
            return "eye.slash.fill"
        case .repeatPassword:
            return "eye.slash.fill"
        }
    }

    var keyboardType: UIKeyboardType {
        switch type {
        case .email:
            return .emailAddress
        default:
            return .default
        }
    }

    var autoCapitalization: TextInputAutocapitalization {
        switch type {
        case .fullname:
            return .words
        default:
            return .never
        }
    }

    var autocorrectionDisabled: Bool {
        switch type {
        case .username:
            return false
        default:
            return true
        }
    }
}
