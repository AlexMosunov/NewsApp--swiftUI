//
//  RegistrationSubViews.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.10.2022.
//

import SwiftUI
import Photos

enum RegistrationTextFieldType: Int, Hashable, CaseIterable {
    case email
    case fullname
    case username
    case password
    case repeatPassword
}

enum LoginTextFieldType: Int, Hashable, CaseIterable {
    case email
    case password
}

struct AuthTextFieldViewModel {

    let type: RegistrationTextFieldType

    var placeholder: String {
        switch type {
        case .email:
            return "Email Address"
        case .username:
            return "Username"
        case .fullname:
            return "Fullname"
        case .password:
            return "Password"
        case .repeatPassword:
            return "Repeat Password"
        }
    }

    var imageName: String {
        switch type {
        case .email:
            return "envelope.fill"
        case .username:
            return "person.crop.rectangle"
        case .fullname:
            return "person.crop.rectangle"
        case .password:
            return "eye.slash.fill"
        case .repeatPassword:
            return "eye.slash.fill"
        }
    }

    var keyboardType: UIKeyboardType {
        switch type {
        case .email:
            return .emailAddress
        default:
            return .default
        }
    }

    var autoCapitalization: TextInputAutocapitalization {
        switch type {
        case .fullname:
            return .words
        default:
            return .never
        }
    }

    var autocorrectionDisabled: Bool {
        switch type {
        case .username:
            return false
        default:
            return true
        }
    }
}

struct RegistrationTextField: View {
    @Binding var text: String
    @FocusState var focusInput: RegistrationTextFieldType?
    let viewModel: AuthTextFieldViewModel
    @Binding var validationError: String?
    @Binding var showError: Bool
    @Binding var isValid: Bool

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: viewModel.imageName)
                    .foregroundColor(.orange)
                    .frame(width: 20)
                ValidatedTextField(
                    text: $text, isValid: _isValid,
                    validationError: $validationError,
                    showError: $showError,
                    focusInput: _focusInput,
                    viewModel: viewModel
                )
                    .keyboardType(viewModel.keyboardType)
                    .textInputAutocapitalization(viewModel.autoCapitalization)
                    .disableAutocorrection(viewModel.autocorrectionDisabled)
                    .frame(height: 40)
                    .focused($focusInput, equals: viewModel.type)
            }
            Divider().background(.gray)
        }
    }
}

struct CustomSecureField: View {
    @Binding var password: String
    @FocusState var focusInput: RegistrationTextFieldType?
    let viewModel: AuthTextFieldViewModel

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: viewModel.imageName)
                    .foregroundColor(.orange)
                SecureField(viewModel.placeholder, text: $password)
                    .frame(height: 40)
                    .focused($focusInput, equals: viewModel.type)
            }
            Divider().background(.gray)
        }
    }
}

struct ActionButtonView: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.headline)
            .foregroundColor(ColorScheme.backgroundColor)
            .padding()
            .frame(width: 220, height: 60)
            .background(.orange)
            .cornerRadius(35)
    }
}
