//
//  SignUpScreen.swift
//  NewsApp-SwiftUI
//
//  Created by User on 05.10.2022.
//

import SwiftUI

struct SignUpScreen: View {
    @State var selectedImage: UIImage?
    @State var showImagePicker: Bool = false
    @State var email: String = ""
    @State var username: String = ""
    @State var fullname: String = ""
    @State var password: String = ""
    @State var repeatPassword: String = ""

    @FocusState var focusedInput: RegistrationTextFieldType?

    @State var errorText: String?
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    @State var isValid = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel

    var textfieldsAreEmtpy: Bool {
        email.isEmpty || username.isEmpty || fullname.isEmpty
        || password.isEmpty || repeatPassword.isEmpty
    }

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .center) {
                    VStack {
                        AvatarImage(selectedImage: $selectedImage)
                            .onTapGesture {
                                showImagePicker.toggle()
                            }
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(image: $selectedImage)
                            }
                        RegistrationTextField(text: $email, focusInput: _focusedInput, viewModel: .init(type: .email), validationError: $errorText, showError: $showError, isValid: $isValid)
                            .padding(.horizontal)
                            .padding(.top, 40)
                        RegistrationTextField(text: $fullname, focusInput: _focusedInput, viewModel: .init(type: .fullname), validationError: $errorText, showError: $showError, isValid: $isValid)
                            .padding(.horizontal)
                            .padding(.top, 30)
                        RegistrationTextField(text: $username, focusInput: _focusedInput, viewModel: .init(type: .username), validationError: $errorText, showError: $showError, isValid: $isValid)
                            .padding(.horizontal)
                            .padding(.top, 30)
                        CustomSecureField(password: $password, focusInput: _focusedInput, viewModel: .init(type: .password), validationError: $errorText, showError: $showError, isValid: $isValid)
                            .padding(.horizontal)
                            .padding(.top, 30)
                        CustomSecureField(password: $repeatPassword, focusInput: _focusedInput, viewModel: .init(type: .repeatPassword), validationError: $errorText, showError: $showError, isValid: $isValid)
                            .padding(.horizontal)
                            .padding(.top, 30)
                        registerButton
                            .padding(.top, 30)
                        secondaryActionButton
                            .padding(.top, 10)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    keyboardButton
                                }
                            }
                    }
                    if isLoading {
                        ProgressView()
                    }
                }
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error Signing up"),
                          message: Text(errorText ?? ""),
                          dismissButton: .default(Text("Ok")))
                }
                .navigationBarHidden(true)
            }
            .background(ColorScheme.backgroundColor)

        }
    }

    private var keyboardButton: some View {
        Button(focusedInput == RegistrationTextFieldType.allCases.last ? "Done" : "Next") {
            guard let currentInput = focusedInput,
                  let lastIndex = RegistrationTextFieldType.allCases.last?.rawValue else {
                return
            }
            let index = min(currentInput.rawValue + 1, lastIndex)
            if focusedInput == RegistrationTextFieldType.allCases.last {
                focusedInput = nil
            } else {
                focusedInput = RegistrationTextFieldType(rawValue: index)
            }
        }
    }

    private var registerButton: some View {
        Button {
            let userCredentials = UserCredentials(
                email: email, password: password,
                repeatPassword: repeatPassword, username: username,
                fullname: fullname, profileImage: selectedImage)
            isLoading = true
            viewModel.registerUser(userCredentials) { error in
                isLoading = false
                if let error = error {
                    errorText = error.localizedDescription
                    showError.toggle()
                    return
                }
            }
        } label: {
            ActionButtonView(title: "Sign Up")
                .opacity(isValid == false || textfieldsAreEmtpy ? 0.5 : 1.0)
        }
        .disabled(isValid == false || textfieldsAreEmtpy)
    }

    private var secondaryActionButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Sign In?")
                .font(.callout)
                .bold()
                .foregroundColor(.orange)
                .underline(true, color: .orange)
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
            .preferredColorScheme(.dark)
    }
}
