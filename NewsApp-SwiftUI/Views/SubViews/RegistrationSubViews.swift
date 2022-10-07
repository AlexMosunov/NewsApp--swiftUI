//
//  RegistrationSubViews.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.10.2022.
//

import SwiftUI

struct RegistrationTextField: View {
    @Binding var text: String
    let placeholder: String
    let imageName: String

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: imageName)
                    .foregroundColor(.orange)
                    .frame(width: 20)
                TextField(placeholder, text: $text)
                    .frame(height: 40)
            }
            Divider().background(.gray)
        }
    }
}

struct CustomSecureField: View {
    @Binding var password: String

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "eye.slash.fill")
                    .foregroundColor(.orange)
                SecureField("Password", text: $password)
                    .frame(height: 40)
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
