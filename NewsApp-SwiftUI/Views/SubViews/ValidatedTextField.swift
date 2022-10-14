//
//  ValidatedTextField.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 14.10.2022.
//

import SwiftUI

struct ValidatedTextField: View {
    @Binding var text: String
    @FocusState var isTextFieldFocused: Bool
    @Binding var isValid: Bool

    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("Text Field", text: $text)
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) { isFocused in
                    if isFocused {
                        print("Began editing")
                    } else {
                        print("ended editing")
                        isValid = validatePassword(text).isValid
                    }
                }
            Button {
                print("DEBUG: tapped")
            } label: {
                Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .tint(.red)
            }

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
        case atLeastOneSymbol = "Please use at least one of symbols !&^%$#@()/]+.* in your password"
        case atLeastOneLowercased = "Please use at least one lowercased character in your password"
    }

    enum EmailErrors: String {
        case emailIsNotValid = "Please use valid email address"
    }

    enum FullnameErrors: String {
        case fullnameIsNotValid = "Please use valid fullname (name + surname)"
    }
}

struct ValidatedTextField_Previews: PreviewProvider {
    static var previews: some View {
        ValidatedTextField(text: .constant("text"), isValid: .constant(true))
    }
}
