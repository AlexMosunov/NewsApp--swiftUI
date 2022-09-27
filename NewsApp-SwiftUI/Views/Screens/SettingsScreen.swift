//
//  SettingsScreen.swift
//  NewsApp-SwiftUI
//
//  Created by User on 20.09.2022.
//

import SwiftUI
import CoreData

struct SettingsScreen: View {
    @Binding var settingsFilter: SettingsFilter

    @State private var draftSettingsFilter: SettingsFilter
    @Environment(\.presentationMode) var presentationMode

    init(settingsFilter: Binding<SettingsFilter>) {
        _settingsFilter = settingsFilter
        _draftSettingsFilter = State(wrappedValue: settingsFilter.wrappedValue)
    }

    var body: some View {
        NavigationView {
            let viewModel = SettingsViewModel(
                draftFromDate: $draftSettingsFilter.fromDate,
                draftToDate: $draftSettingsFilter.toDate
            )
            Form {
                Section(viewModel.datesSectionTitle) {
                    DatePickerView(
                        viewModel: .init(
                            type: .from,
                            draftSettingsFilter: $draftSettingsFilter
                        )
                    )
                    DatePickerView(
                        viewModel: .init(
                            type: .to,
                            draftSettingsFilter: $draftSettingsFilter
                        )
                    )
                    DiscardButtonLabelView(viewModel: viewModel)
                }
                Section(viewModel.languagesSectionTitle) {
                    Picker(
                        viewModel.languageTitle,
                        selection: $draftSettingsFilter.language
                    ) {
                        ForEach(Languages.allCases, id: \.rawValue) { language in
                            Text(language.rawValue.localiseToLanguage())
                                .tag(language)
                        }
                    }
                }
            }
            .navigationTitle(viewModel.navTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(viewModel.cancelTitle) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.saveTitle) {
                        settingsFilter = draftSettingsFilter
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct DatePickerView: View {
    var viewModel: SettingsDatePicker
    var displayOnlyDate: Bool = false

    var body: some View {
        DatePicker(
            viewModel.title,
            selection: viewModel.selectedDate,
            in: viewModel.dateRange,
            displayedComponents: displayOnlyDate ?
                                 .date : [.hourAndMinute, .date]
        )
    }
}

struct DiscardButtonLabelView: View {
    var viewModel: SettingsViewModel

    var body: some View {
        HStack {
            Spacer()
            Button {
                viewModel.updateDates()
            } label: {
                DiscardButtonLabel(viewModel: viewModel.discardButton)
            }
            Spacer()
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct DiscardButtonLabel: View {
    var viewModel: DiscardButtonViewModel

    var body: some View {
        Label(
            viewModel.title,
            systemImage: viewModel.imageName
        )
        .frame(width: 150, height: 35, alignment: .center)
        .background(viewModel.color)
        .foregroundColor(.white)
        .cornerRadius(12)
        .padding(5)
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(settingsFilter: .constant(SettingsFilter(
            fromDate: Date(),
            toDate: Date(),
            language: .en,
            selection: .business
        )))
    }
}
