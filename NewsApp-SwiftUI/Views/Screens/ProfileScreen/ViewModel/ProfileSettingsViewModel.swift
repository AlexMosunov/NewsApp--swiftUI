//
//  ProfileSettingsViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by User on 27.10.2022.
//

import SwiftUI

enum ProfileSettingsActionType: Int, Hashable, CaseIterable {
    case editUsername
    case editBio
    case signOut
    case deleteUser
}

struct ProfileSettingsViewModel {

    let type: ProfileSettingsActionType

    var editTextViewModel: SettingsEditTextViewModel {
        switch type {
        case .editUsername:
            return .init(type: .username)
        case .editBio:
            return .init(type: .bio)
        default:
            return .init(type: .username)
        }
    }

    var leftIconName: String {
        switch type {
        case .editUsername:
            return "pencil"
        case .editBio:
            return "text.quote"
        case .signOut:
            return "figure.walk"
        case .deleteUser:
            return "minus.circle.fill"
        }
    }

    var text: String {
        switch type {
        case .editUsername:
            return "Display Name"
        case .editBio:
            return "Bio"
        case .signOut:
            return "Sign out"
        case .deleteUser:
            return "Delete user"
        }
    }

    var color: Color {
        switch type {
        case .deleteUser:
            return .red
        default:
            return .orange
        }
    }
}
