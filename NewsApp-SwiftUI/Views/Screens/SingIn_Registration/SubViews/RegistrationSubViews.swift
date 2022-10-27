//
//  RegistrationSubViews.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.10.2022.
//

import SwiftUI
import Photos

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
    @Binding var validationError: String?
    @Binding var showError: Bool
    @Binding var isValid: Bool

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: viewModel.imageName)
                    .foregroundColor(.orange)
                ValidatedTextField(
                    text: $password, isValid: _isValid,
                    validationError: $validationError,
                    showError: $showError,
                    focusInput: _focusInput,
                    viewModel: viewModel
                )
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
