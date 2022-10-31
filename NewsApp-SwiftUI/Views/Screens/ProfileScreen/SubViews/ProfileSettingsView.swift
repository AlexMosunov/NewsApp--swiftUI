//
//  ProfileSettingsView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 05.10.2022.
//

import SwiftUI

struct ProfileSettingsView: View {
    @State var showSignOutAlert: Bool = false
    @State var showDeleteUserAlert: Bool = false
    @State var showReauthUserAlert: Bool = false
    @State var shouldReAuth: Bool = false
    @State var showError: Bool = false
    @State var errorText: String = ""
    @EnvironmentObject var viewModel: AuthViewModel

    @State var email: String = ""
    @State var password: String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            GroupBox(label: SettingsLabelView(
                labelText: "Profile",
                labelImage: "person.fill")
            ) {
                ProfileNavigationLinkView(viewModel: .init(type: .editUsername), submissionText: viewModel.user?.username ?? "")
                ProfileNavigationLinkView(viewModel: .init(type: .editBio), submissionText: viewModel.user?.bio ?? "")
                .alert(isPresented: $showError) {
                    Alert(
                        title: Text("Error deleting acccount"),
                        message: Text(errorText),
                        dismissButton: .default(Text(Localized.general_ok))
                    )
                }
                ProfileButtonView(viewModel: .init(type: .signOut), actionBool: $showSignOutAlert)
                .alert(isPresented: $showSignOutAlert) {
                    Alert(title: Text(Localized.profile_sign_out),
                          primaryButton: .default(Text(Localized.general_yes)) {
                        viewModel.signOut()
                    }, secondaryButton: .cancel())
                }
                ProfileButtonView(viewModel: .init(type: .deleteUser), actionBool: $showDeleteUserAlert)
                .alert(isPresented: $showDeleteUserAlert) {
                    Alert(title: Text(Localized.profile_delete_user),
                          primaryButton: .default(Text(Localized.general_yes)) {
                        showReauthUserAlert.toggle()
                    }, secondaryButton: .cancel())
                }
            }
            AboutAppGroupBoxView()
        }
        .padding(.bottom, 20)
        .fullScreenCover(isPresented: $showReauthUserAlert, onDismiss: {
            guard shouldReAuth else {
                return
            }
            viewModel.reauthenticateAndDelete(
                email: email,
                password: password) { error in
                    if let error = error {
                        errorText = error.localizedDescription
                        email = ""
                        password = ""
                        showError.toggle()
                    }
                }
        }, content: {
            ReAuthenticateView(email: $email, password: $password, showAlert: $showReauthUserAlert, shouldReAuth: $shouldReAuth)
                .transaction({ transaction in
                    transaction.animation = .easeOut
                })
        })
    }
}

struct SettingsLabelView: View {
    var labelText: String
    var labelImage: String

    var body: some View {
        VStack {
            HStack {
                Text(labelText)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: labelImage)
            }
            Divider()
                .padding(.vertical, 4)
        }
    }
}

struct SettingsRowView: View {
    var viewModel: ProfileSettingsViewModel

    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(viewModel.color)
                Image(systemName: viewModel.leftIconName)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            Text(viewModel.text)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

struct AboutAppGroupBoxView: View {
    var body: some View {
        GroupBox(label: SettingsLabelView(
            labelText: "WorldNews",
            labelImage: "newspaper.fill")
        ) {
            HStack(alignment: .center, spacing: 10) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80, alignment: .center)
                    .cornerRadius(12)
                Text(Localized.profile_about_app)
                    .font(.footnote)
            }
        }
    }
}

struct ProfileNavigationLinkView: View {
    var viewModel: ProfileSettingsViewModel
    var submissionText: String
    var body: some View {
        NavigationLink {
            SettingsEditTextView(submissionText: submissionText ,viewModel: viewModel.editTextViewModel)
        } label: {
            SettingsRowView(viewModel: viewModel)
        }
    }
}

struct ProfileButtonView: View {
    var viewModel: ProfileSettingsViewModel
    @Binding var actionBool: Bool
    var body: some View {
        Button {
            actionBool.toggle()
        } label: {
            SettingsRowView(viewModel: viewModel)
        }
    }
}
