//
//  SettingsScreen.swift
//  NewsApp-SwiftUI
//
//  Created by User on 20.09.2022.
//

import SwiftUI
import CoreData

struct SettingsScreen: View {
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @State private var draftFromDate: Date
    @State private var draftToDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    init(fromDate: Binding<Date>, toDate: Binding<Date>) {
        _fromDate = fromDate
        _toDate = toDate
        _draftFromDate = State(wrappedValue: fromDate.wrappedValue)
        _draftToDate = State(wrappedValue: toDate.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Select news dates range") {
                    DatePickerView(
                        title: "From",
                        selectedDate: $draftFromDate,
                        lhs: Constants.maxDaysAgoDate,
                        rhs: draftToDate
                    )
                    DatePickerView(
                        title: "To",
                        selectedDate: $draftToDate,
                        lhs: draftFromDate,
                        rhs: Date.now
                    )
                    DiscardButtonLabelView(
                        title: "Discard", imageName: "clear", color: .pink,
                        draftFromDate: $draftFromDate, draftToDate: $draftToDate
                    )
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
                        fromDate = draftFromDate
                        toDate = draftToDate
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
        SettingsScreen(fromDate: .constant(Date()), toDate: .constant(Date()))
    }
}
