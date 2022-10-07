//
//  ProfileSettingsView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 05.10.2022.
//

import SwiftUI

struct ProfileSettingsView: View {
//    @State var showImagePicker: Bool = false
//    @State var selectedImage: UIImage
//    @State var sourceType: UIImagePickerController.SourceType = .
    @State var showAlert: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            GroupBox(label: SettingsLabelView(
                labelText: "Profile",
                labelImage: "person.fill")
            ) {
                NavigationLink {
                    SettingsEditTextView(
                        submissionText: viewModel.user?.username ?? "",
                        title: "Username",
                        description: "You can edit your username here.",
                        placeholder: "Your username..",
                        settingsEditTextOption: .username
                    )
                } label: {
                    SettingsRowView(leftIcon: "pencil", text: "Display Name", color: .orange)
                }
                NavigationLink {
                    SettingsEditTextView(
                        submissionText: viewModel.user?.bio ?? "",
                        title: "Bio",
                        description: "You can edit your bio here.",
                        placeholder: "Write something about yourself..",
                        settingsEditTextOption: .bio
                    )
                } label: {
                    SettingsRowView(leftIcon: "text.quote", text: "Bio", color: .orange)
                }
                Button {
//                    showAlert.toggle()
                } label: {
                    SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: .orange)
                }
                Button {
                    showAlert.toggle()
                } label: {
                    SettingsRowView(leftIcon: "figure.walk", text: "Sign out", color: .orange)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Are you sure you want to sign out?"),
                          primaryButton: .default(Text("Yes")) {
                        viewModel.signOut()
                    }, secondaryButton: .cancel())
                }
            }
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
                    Text("WorldNews is perfect app for browsing latest news across the whole world. Choose differnet languages, topics, countries and sources. Safe your favourite articles and share with friends! Browse news even without Internet conncetion! Everything in one app.")
                        .font(.footnote)
                }
            }
        }
        .padding(.bottom, 20)
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
    var leftIcon: String
    var text: String
    var color: Color

    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                Image(systemName: leftIcon)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            Text(text)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
////            .previewLayout(.sizeThatFits)
//    }
//}
