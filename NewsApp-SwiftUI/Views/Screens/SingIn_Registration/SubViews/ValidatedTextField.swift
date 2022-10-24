//
//  ValidatedTextField.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 14.10.2022.
//

import SwiftUI

struct ValidatedTextField: View {
    @Binding var text: String
    @Binding var isValid: Bool
    @Binding var validationError: String?
    @Binding var showError: Bool
    @FocusState var focusInput: RegistrationTextFieldType?
    let viewModel: AuthTextFieldViewModel

    @State var showButton = false
    var body: some View {
        ZStack(alignment: .trailing) {
            if viewModel.secureEntry {
                SecureField(viewModel.placeholder, text: $text)
                    .onChange(of: text) { _ in
                        performValidation(isEditing: false, text: text)
                    }
            } else {
                TextField(viewModel.placeholder, text: $text, onEditingChanged: { isEditing in
                    performValidation(isEditing: isEditing, text: text)
                })
            }

            if showButton {
                Button {
                    focusInput = viewModel.type
                    showError = true
                    validationError = validate(text)
                } label: {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .tint(.red)
                }
                .padding(.trailing, 15)
            }

        }
    }

    private func performValidation(isEditing: Bool, text: String) {
        guard !isEditing && !text.isEmpty && viewModel.shouldValidate else {
            return
        }
        validationError = validate(text)
        isValid = validationError == nil
        showButton = !isValid
    }

    private func validate(_ text: String) -> String? {
        guard !text.isEmpty else {
            return GeneralErrors.emptyField.rawValue
        }
        switch viewModel.type {
        case .fullname:
            return validateFullname(text).error?.rawValue
        case .email:
            return validateEmail(text).error?.rawValue
        case .password:
            return validatePassword(text).error?.rawValue
        default:
            return nil
        }
    }

    private func validateFullname(_ fullname: String) -> (isValid: Bool, error: FullnameErrors?) {
        guard NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z-]+ ?.* [a-zA-Z-]+$")
                .evaluate(with: fullname) else {
                    return (false, .fullnameIsNotValid)
                }
        return (true, nil)
    }

    private func validateEmail(_ email: String) -> (isValid: Bool, error: EmailErrors?) {
        let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegEx = name + "@" + domain + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValid = emailPredicate.evaluate(with: email)
        return isValid ? (isValid, nil) : (isValid, .emailIsNotValid)
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func validatePassword(_ password: String) -> (isValid: Bool, error: PasswordErrors?) {
        if password.count < 8 {
            return (false, .tooShort)
        }
        if !NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password) {
            return (false, .atLeastOneUppercase)
        }
        if !NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password) {
            return (false, .atLeastOneDigit)
        }

        if !NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: password) {
            return (false, .atLeastOneSymbol)
        }

        if !NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password) {
            return (false, .atLeastOneLowercased)
        }

        return (true, nil)
    }

    enum PasswordErrors: String {
        case tooShort = "Please enter the password that is longer then 6 symbols"
        case atLeastOneUppercase = "Please use at least one uppercased character in your password"
        case atLeastOneDigit = "Please use at least one digit in your password"
        case atLeastOneSymbol = "Please use at least one of symbols !&^%$#@()/ in your password"
        case atLeastOneLowercased = "Please use at least one lowercased character in your password"
    }

    enum EmailErrors: String {
        case emailIsNotValid = "Please use valid email address"
    }

    enum FullnameErrors: String {
        case fullnameIsNotValid = "Please use valid fullname (name + surname)"
    }

    enum GeneralErrors: String {
        case emptyField = "The textfield is empty"
    }
}
