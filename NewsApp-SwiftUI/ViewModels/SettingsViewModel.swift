//
//  SettingsViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by User on 27.09.2022.
//

import SwiftUI

struct SettingsViewModel {
    @Binding var draftFromDate: Date
    @Binding var draftToDate: Date

    let discardButton = DiscardButtonViewModel()

    func updateDates() {
        draftFromDate = Constants.maxDaysAgoDate
        draftToDate = Date.now
    }

    var datesSectionTitle: LocalizedStringKey {
        Localized.setings_select_dates
    }

    var languagesSectionTitle: LocalizedStringKey {
        Localized.settings_select_language
    }

    var languageTitle: LocalizedStringKey {
        Localized.settings_language
    }

    var navTitle: LocalizedStringKey {
        Localized.settings_nav_title
    }

    var cancelTitle: LocalizedStringKey {
        Localized.settings_cancel
    }

    var saveTitle: LocalizedStringKey {
        Localized.settings_save
    }
}

struct DiscardButtonViewModel {
    var title: LocalizedStringKey { Localized.settings_discard }
    var imageName: String { "clear" }
    var color: Color { .pink }
}

struct SettingsDatePicker {
    enum DatePickerType {
        case from
        case to
    }

    var type: DatePickerType
    @Binding var draftSettingsFilter: SettingsFilter

    var title: LocalizedStringKey {
        switch type {
        case .from:
            return Localized.setings_from
        case .to:
            return Localized.settings_to
        }
    }

    var dateRange: ClosedRange<Date> {
        switch type {
        case .from:
            return Constants.maxDaysAgoDate...draftSettingsFilter.toDate
        case .to:
            return draftSettingsFilter.fromDate...Date.now
        }
    }

    var selectedDate: Binding<Date> {
        switch type {
        case .from:
            return $draftSettingsFilter.fromDate
        case .to:
            return $draftSettingsFilter.toDate
        }
    }
}
