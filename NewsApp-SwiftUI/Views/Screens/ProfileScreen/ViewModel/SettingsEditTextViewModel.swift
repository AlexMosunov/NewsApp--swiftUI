//
//  SettingsEditTextViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by User on 27.10.2022.
//

import SwiftUI

enum SettingsEditTextOption: String {
    case username
    case bio

    var localisedName: LocalizedStringKey {
        switch self {
        case .username:
            return Localized.profile_username
        case .bio:
            return Localized.profile_bio
        }
    }
}

struct SettingsEditTextViewModel {

    let type: SettingsEditTextOption

    var title: LocalizedStringKey {
        switch type {
        case .username:
            return Localized.profile_username
        case .bio:
            return Localized.profile_bio
        }
    }

    var description: LocalizedStringKey {
        switch type {
        case .username:
            return Localized.profile_edit_username
        case .bio:
            return Localized.profile_edit_bio
        }
    }

    var placeholder: LocalizedStringKey {
        switch type {
        case .username:
            return Localized.profile_username_placeholder
        case .bio:
            return Localized.profile_bio_placeholder
        }
    }

    var sucessMessage: String {
        switch type {
        case .username:
            return Localized.profile_success_edited_username.toString() ?? ""
        case .bio:
            return Localized.profile_success_edited_bio.toString() ?? ""
        }
    }
}
