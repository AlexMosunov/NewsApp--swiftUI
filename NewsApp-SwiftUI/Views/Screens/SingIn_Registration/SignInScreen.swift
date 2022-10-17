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
    @State var isLoading: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel

    @FocusState var focusedInput: RegistrationTextFieldType?

    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                VStack {
                    LogoImage()
                    RegistrationTextField(text: $email, focusInput: _focusedInput, viewModel: .init(type: .email))
                        .padding(.horizontal)
                        .padding(.top, 40)
                    CustomSecureField(password: $password, focusInput: _focusedInput, viewModel: .init(type: .password))
                        .padding(.horizontal)
                        .padding(.top, 30)
                    HStack {
                        Spacer()
                        Button {
                            errorText = "TODO"
                            showError.toggle()
                        } label: {
                            Text("Forget Password?")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    Button {
                        isLoading = true
                        viewModel.login(withEmail: email, password: password) { errorString in
                            isLoading = false
                            if let errorString = errorString {
                                errorText = errorString
                                showError.toggle()
                            }
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
            }
            .frame(maxHeight: .infinity)
            .background(ColorScheme.backgroundColor)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(focusedInput == .password ? "Done" : "Next") {
                        if focusedInput == .email {
                            focusedInput = .password
                        } else {
                            focusedInput = nil
                        }
                    }
                }
            }
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
