//
//  SignInScreen.swift
//  NewsApp-SwiftUI
//
//  Created by User on 06.10.2022.
//

import SwiftUI
import Firebase

struct SignInScreen: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var errorText: String?
    @State var showError = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                LogoImage()
                RegistrationTextField(text: $email, placeholder: "Email Address", imageName: "envelope.fill")
                    .padding(.horizontal)
                    .padding(.top, 40)
                CustomSecureField(password: $password)
                    .padding(.horizontal)
                    .padding(.top, 30)

                HStack {
                    Spacer()
                    Button {

                    } label: {
                        Text("Forget Password?")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                Button {
                    viewModel.login(withEmail: email, password: password) { errorString in
                        errorText = errorString
                        showError.toggle()
                    }
                } label: {
                    ActionButtonView(title: "Login")
                }
                .padding(.top, 30)
                NavigationLink {
                    SignUpScreen()
                } label: {
                    Text("Sign Up?")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.orange)
                        .underline(true, color: .orange)
                }
                .padding(.top, 10)
            }
            .frame(maxHeight: .infinity)
            .background(ColorScheme.backgroundColor)
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error Logging in"),
                  message: Text(errorText ?? ""),
                  dismissButton: .default(Text("Ok")))
        }
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
