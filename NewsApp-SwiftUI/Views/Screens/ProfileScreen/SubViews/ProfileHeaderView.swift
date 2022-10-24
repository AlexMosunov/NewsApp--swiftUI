//
//  ProfileHeaderView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 05.10.2022.
//

import SwiftUI

struct ProfileHeaderView: View {
    @Binding var selectedImage: UIImage?
    @State var showImagePicker: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack(alignment: .bottomTrailing) {
                UrlImageView(url: URL(string: viewModel.user?.profileImageUrl ?? ""), defaultImageName: "avatar")
                    .scaledToFill()
                    .frame(width: 120, height: 120, alignment: .center)
                    .cornerRadius(60)
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.orange)
                    .onTapGesture {
                        showImagePicker.toggle()
                    }
                    .sheet(isPresented:  $showImagePicker, onDismiss: {
                        if let image = selectedImage {
                            viewModel.editProfileImage(image)
                        }
                    }, content: {
                        ImagePicker(image: $selectedImage)
                    })
            }
            Text(viewModel.user?.username ?? "")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(viewModel.user?.fullname ?? "")
                .font(.caption)
                .fontWeight(.light)
            Text(viewModel.user?.bio ?? "Edit your bio")
                .font(.body)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct AvatarImage: View {
    @Binding var selectedImage: UIImage?
    var defaultImage = UIImage(named: "avatar")

    var body: some View {
        if selectedImage == nil {
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80, alignment: .center)
        } else {
            Image(uiImage: selectedImage ?? defaultImage!)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .cornerRadius(60)
        }
    }
}

struct LogoImage: View {
    var body: some View {
        Image("logo")
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120, alignment: .center)
            .cornerRadius(60)
    }
}
