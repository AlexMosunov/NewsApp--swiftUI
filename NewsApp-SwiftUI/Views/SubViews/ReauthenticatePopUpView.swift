//
//  ReauthenticatePopUpView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 25.10.2022.
//

import SwiftUI

struct ReAuthenticateView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var showAlert: Bool
    @Binding var shouldReAuth: Bool
    var title = "Please reauthenticate"

    var authButtonIsEnabled: Bool {
        !password.isEmpty && !email.isEmpty
    }

    var body: some View {
        ZStack {
            Color(.black).opacity(0.2)
                .ignoresSafeArea()
            VStack {
                Text(title)
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                SecureField("Enter your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("ReAuthenticate") {
                    shouldReAuth = true
                    showAlert = false
                }
                .padding(.vertical, 15)
                .frame(width: 200)
                .background(Color.blue)
                .cornerRadius(8)
                .foregroundColor(.white)
                .opacity(authButtonIsEnabled ? 1 : 0.5)
                .disabled(!authButtonIsEnabled)
                Button("Cancel") {
                    shouldReAuth = false
                    showAlert = false
                }
                .padding(8)
                .foregroundColor(.primary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }
            .padding()
            .frame(width: 250, height: 250)
            .background(Color(.lightGray))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 20)
        }
    }
}

struct ReAuthenticateView_Previews: PreviewProvider {
    static var previews: some View {
        ReAuthenticateView(email: .constant(""), password: .constant(""), showAlert: .constant(true), shouldReAuth: .constant(false))
    }
}
