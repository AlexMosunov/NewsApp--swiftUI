//
//  Localized.swift
//  NewsApp-SwiftUI
//
//  Created by User on 27.09.2022.
//

import SwiftUI

public enum Localized {
    public static let general_ok = LocalizedStringKey("general_ok")
    public static let general_yes = LocalizedStringKey("general_yes")
    public static let general_success = LocalizedStringKey("general_success")
    public static let general_error = LocalizedStringKey("general_error")
    public static let general_save = LocalizedStringKey("general_save")
    public static let general_loading = LocalizedStringKey("general_loading")

    public static let setings_select_dates = LocalizedStringKey("setings_select_dates")
    public static let setings_from = LocalizedStringKey("setings_from")
    public static let settings_to = LocalizedStringKey("settings_to")
    public static let settings_discard = LocalizedStringKey("settings_discard")
    public static let settings_select_language = LocalizedStringKey("settings_select_language")
    public static let settings_select_country = LocalizedStringKey("settings_select_country")
    public static let settings_nav_title = LocalizedStringKey("settings_nav_title")
    public static let settings_language = LocalizedStringKey("settings_language")
    public static let settings_country = LocalizedStringKey("settings_country")
    public static let settings_cancel = LocalizedStringKey("settings_cancel")
    public static let settings_save = LocalizedStringKey("settings_save")
    public static let settings_unselected = LocalizedStringKey("settings_unselected")
    public static let settings_picker_alert_title = LocalizedStringKey("settings_picker_alert_title")
    public static let settings_picker_alert_message = LocalizedStringKey("settings_picker_alert_message")
    public static let sources_title = LocalizedStringKey("sources_title")
    public static let headlines_title = LocalizedStringKey("headlines_title")
    public static let tabview_headlines = LocalizedStringKey("tabview_headlines")
    public static let tabview_sources = LocalizedStringKey("tabview_sources")
    public static let tabview_favourites = LocalizedStringKey("tabview_favourites")
    public static let tabview_search = LocalizedStringKey("tabview_search")
    public static let tabview_profile = LocalizedStringKey("tabview_profile")
    public static let article_favourite_add = LocalizedStringKey("article_favourite_add")
    public static let article_favourite_remove = LocalizedStringKey("article_favourite_remove")

    public static let profile_about_app = LocalizedStringKey("profile_about_app")
    public static let profile_sign_out = LocalizedStringKey("profile_sign_out")
    public static let profile_delete_user = LocalizedStringKey("profile_delete_user")
    public static let profile_edit_bio = LocalizedStringKey("profile_edit_bio")
    public static let profile_edit_username = LocalizedStringKey("profile_edit_username")
    public static let profile_username = LocalizedStringKey("profile_username")
    public static let profile_bio = LocalizedStringKey("profile_bio")
    public static let profile_username_placeholder = LocalizedStringKey("profile_username_placeholder")
    public static let profile_bio_placeholder = LocalizedStringKey("profile_bio_placeholder")
    public static let profile_success_edited_username = LocalizedStringKey("profile_success_edited_username")
    public static let profile_success_edited_bio = LocalizedStringKey("profile_success_edited_bio")

    public static let search_no_results_error = LocalizedStringKey("search_no_results_error")
    public static let search_news_loading_error = LocalizedStringKey("search_news_loading_error")
    public static let search_enter_query = LocalizedStringKey("search_enter_query")
    public static let search_find_news = LocalizedStringKey("search_find_news")

    public static let error_deleting_user = LocalizedStringKey("error_deleting_user")
    public static let error_reauth_user = LocalizedStringKey("error_reauth_user")
    public static let error_deleting_image = LocalizedStringKey("error_deleting_image")
    public static let error_loging_user = LocalizedStringKey("error_loging_user")
    public static let error_fetching_user = LocalizedStringKey("error_fetching_user")
    public static let error_registering_user = LocalizedStringKey("error_registering_user")
    public static let error_passwors_does_not_match = LocalizedStringKey("error_passwors_does_not_match")
}

public enum ErrorMessagesLocalised: String, CaseIterable {
    case wrongQuery = "search_no_results_error"
    case errorDeletingUser = "error_deleting_user"
    case errorReauthUser = "error_reauth_user"
    case errorDeletingImage = "error_deleting_image"
    case errorLogingUser = "error_loging_user"
    case errorFetchingUser = "error_fetching_user"
    case errorRegisteringUser = "error_registering_user"
    case passwordsDoNotmatch = "error_passwors_does_not_match"
    case errorShortUsername = "error_short_username"
    case errorShortBio = "error_short_bio"
}

