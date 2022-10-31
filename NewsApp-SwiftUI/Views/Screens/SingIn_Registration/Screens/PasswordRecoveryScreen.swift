//
//  PasswordRecoveryScreen.swift
//  NewsApp-SwiftUI
//
//  Created by User on 31.10.2022.
//

import SwiftUI

struct PasswordRecoveryScreen: View {
    @State var text: String = ""
    @State var alertText: String?
    @State var showAlert = false
    @State var isLoading: Bool = false
    @State var success: Bool = false

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            VStack {
                LogoImage()
                Text("We will send recovery link to your email address")
                    .padding(.top, 50)
                textField
                    .padding(.horizontal)
                sendButton
                    .padding(.top, 50)
            }
            if isLoading {
                ProgressView()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(success ? Localized.general_success : Localized.general_error),
                message: Text(alertText ?? ""),
                dismissButton: .default(Text(Localized.general_ok), action: {
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    }
                }))
        }
    }

    var sendButton: some View {
        Button {
            isLoading = true
            viewModel.sendPasswordReset(withEmail: text) { error in
                isLoading = false
                success = error == nil
                alertText = error?.localizedDescription ?? "Recovery link has been send to your email address"
                showAlert.toggle()
            }
        } label: {
            ActionButtonView(title: "Send")
                .opacity(text.isEmpty ? 0.5 : 1.0)
                .disabled(text.isEmpty)
        }
    }

    var textField: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.orange)
                    .frame(width: 20)
                TextField("Enter your email address", text: $text)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .frame(height: 40)
            }
            Divider().background(.gray)
        }
    }
}

struct PasswordRecoveryScreen_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRecoveryScreen()
    }
}
