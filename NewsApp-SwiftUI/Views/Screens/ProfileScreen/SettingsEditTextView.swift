//
//  SettingsEditTextView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 05.10.2022.
//

import SwiftUI

enum SettingsEditTextOption: String {
    case username
    case bio
}

struct SettingsEditTextView: View {
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeholder: String
    let settingsEditTextOption: SettingsEditTextOption
    @State var success: Bool = false
    @State var showAlert: Bool = false
    @State var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
                .padding(.leading, 4)
            TextField(placeholder, text: $submissionText)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(ColorScheme.backgroundColor)
                .cornerRadius(12)
                .font(.headline)
                .textInputAutocapitalization(.sentences)
            Button {
                saveText()
            } label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(.orange)
                    .cornerRadius(12)
                    .foregroundColor(ColorScheme.backgroundColor)
            }

            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(success ? "Success!" : "Error"),
                  message: Text(errorMessage ?? "You have successfully edited your \(settingsEditTextOption.rawValue)"),
                  dismissButton: .default(Text("Ok")) {
                if success {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationTitle(title)
    }

    func saveText() {
        guard validate() else {
            showAlert.toggle()
            return
        }
        viewModel.updateUserDisplayName(textType: settingsEditTextOption, username: submissionText) { success, errorMessage  in
            self.showAlert.toggle()
            self.success = success
            self.errorMessage = errorMessage
        }
    }

    func validate() -> Bool {
        switch settingsEditTextOption {
        case .username:
            guard submissionText.count > 2 else {
                self.errorMessage = "Username should be longer than 2 characters"
                return false
            }
        case .bio:
            guard submissionText.count > 5 else {
                self.errorMessage = "Bio should be longer than 5 characters"
                return false
            }
        }
        return true
    }
}

struct SettingsEditTextView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsEditTextView(title: "title", description: "description", placeholder: "placeholder", settingsEditTextOption: .bio)
    }
}
