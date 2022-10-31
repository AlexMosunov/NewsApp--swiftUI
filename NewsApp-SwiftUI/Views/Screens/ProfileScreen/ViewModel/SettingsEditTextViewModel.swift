//
//  SettingsEditTextViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by User on 27.10.2022.
//

import Foundation

enum SettingsEditTextOption: String {
    case username
    case bio
}

struct SettingsEditTextViewModel {

    let type: SettingsEditTextOption

    var title: String {
        switch type {
        case .username:
            return "Username"
        case .bio:
            return "Bio"
        }
    }

    var description: String {
        switch type {
        case .username:
            return "You can edit your username here."
        case .bio:
            return "You can edit your bio here."
        }
    }

    var placeholder: String {
        switch type {
        case .username:
            return "Your username.."
        case .bio:
            return "Write something about yourself.."
        }
    }
}
