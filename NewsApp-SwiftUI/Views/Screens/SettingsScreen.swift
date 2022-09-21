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
    let languageItems = ["ar", "de", "en", "es" ,"fr", "he", "it", "nl", "no", "pt", "ru", "se", "zh" ]
    
    init(settingsFilter: Binding<SettingsFilter>) {
        _settingsFilter = settingsFilter
        _draftSettingsFilter = State(wrappedValue: settingsFilter.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Select news dates range") {
                    DatePickerView(
                        title: "From",
                        selectedDate: $draftSettingsFilter.fromDate,
                        lhs: Constants.maxDaysAgoDate,
                        rhs: draftSettingsFilter.toDate
                    )
                    DatePickerView(
                        title: "To",
                        selectedDate: $draftSettingsFilter.toDate,
                        lhs: draftSettingsFilter.fromDate,
                        rhs: Date.now
                    )
                    DiscardButtonLabelView(
                        title: "Discard", imageName: "clear", color: .pink,
                        draftFromDate: $draftSettingsFilter.fromDate,
                        draftToDate: $draftSettingsFilter.toDate
                    )
                }
                Section("Select language") {
                    Picker("Language", selection: $settingsFilter.language) {
                        ForEach(languageItems, id: \.self) { language in
                            Text(language.localiseToLanguage())
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        settingsFilter = draftSettingsFilter
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct DatePickerView: View {
    var title: String
    var selectedDate: Binding<Date>
    var lhs: Date
    var rhs: Date
    var displayOnlyDate: Bool = false

    var body: some View {
        DatePicker(
            title,
            selection: selectedDate,
            in: lhs...rhs,
            displayedComponents: displayOnlyDate ? .date : [.hourAndMinute, .date]
        )
    }
}

struct DiscardButtonLabelView: View {
    var title: String
    var imageName: String
    var color: Color
    @Binding fileprivate var draftFromDate: Date
    @Binding fileprivate var draftToDate: Date
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                draftFromDate = Constants.maxDaysAgoDate
                draftToDate = Date.now
            } label: {
                DiscardButtonLabel(
                    title: "Discard", imageName: "clear", color: .pink
                )
            }
            Spacer()
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct DiscardButtonLabel: View {
    var title: String
    var imageName: String
    var color: Color

    var body: some View {
        Label(title, systemImage: imageName)
            .frame(width: 150, height: 35, alignment: .center)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(5)
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(settingsFilter: .constant(SettingsFilter(fromDate: Date(), toDate: Date(), language: "en")))
    }
}
