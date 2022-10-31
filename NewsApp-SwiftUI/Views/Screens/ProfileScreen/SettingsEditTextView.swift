//
//  SettingsEditTextView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 05.10.2022.
//

import SwiftUI

struct SettingsEditTextView: View {
    @State var submissionText: String = ""
    var viewModel: SettingsEditTextViewModel

    @State var success: Bool = false
    @State var showAlert: Bool = false
    @State var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authorisation: AuthViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.description)
                .padding(.leading, 4)
            TextField(viewModel.placeholder, text: $submissionText)
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
                Text((Localized.general_save.toString() ?? "Save").uppercased())
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
            Alert(title: Text(success ? Localized.general_success : Localized.general_error),
                  message: Text(errorMessage ?? viewModel.sucessMessage),
                  dismissButton: .default(Text(Localized.general_ok)) {
                if success {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationTitle(viewModel.title)
    }

    func saveText() {
        guard validate() else {
            showAlert.toggle()
            return
        }
        authorisation.updateUserDisplayName(
            textType: viewModel.type,
            username: submissionText
        ) { success, errorMessage  in
            self.showAlert.toggle()
            self.success = success
            self.errorMessage = errorMessage
        }
    }

    func validate() -> Bool {
        switch viewModel.type {
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
        SettingsEditTextView(viewModel: .init(type: .bio))
    }
}
