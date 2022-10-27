//
//  ProfileSettingsView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 05.10.2022.
//

import SwiftUI

enum ProfileSettingsActionType: Int, Hashable, CaseIterable {
    case editUsername
    case editBio
    case signOut
    case deleteUser
}

struct ProfileSettingsViewModel {

    let type: ProfileSettingsActionType

    var editTextViewModel: SettingsEditTextViewModel {
        switch type {
        case .editUsername:
            return .init(type: .username)
        case .editBio:
            return .init(type: .bio)
        default:
            return .init(type: .username)
        }
    }

    var leftIconName: String {
        switch type {
        case .editUsername:
            return "pencil"
        case .editBio:
            return "text.quote"
        case .signOut:
            return "figure.walk"
        case .deleteUser:
            return "minus.circle.fill"
        }
    }

    var text: String {
        switch type {
        case .editUsername:
            return "Display Name"
        case .editBio:
            return "Bio"
        case .signOut:
            return "Sign out"
        case .deleteUser:
            return "Delete user"
        }
    }

    var color: Color {
        switch type {
        case .deleteUser:
            return .red
        default:
            return .orange
        }
    }
}

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
                        dismissButton: .default(Text("Ok"))
                    )
                }
                ProfileButtonView(viewModel: .init(type: .signOut), actionBool: $showSignOutAlert)
                .alert(isPresented: $showSignOutAlert) {
                    Alert(title: Text("Are you sure you want to sign out?"),
                          primaryButton: .default(Text("Yes")) {
                        viewModel.signOut()
                    }, secondaryButton: .cancel())
                }
                ProfileButtonView(viewModel: .init(type: .deleteUser), actionBool: $showDeleteUserAlert)
                .alert(isPresented: $showDeleteUserAlert) {
                    Alert(title: Text("Are you sure you want to delete this user?"),
                          primaryButton: .default(Text("Yes")) {
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
                Text("WorldNews is perfect app for browsing latest news across the whole world. Choose different languages, topics, countries and sources. Safe your favourite articles and share with friends! Search articles on any topic you like! Browse news even without Internet connection! Everything in one app.")
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
