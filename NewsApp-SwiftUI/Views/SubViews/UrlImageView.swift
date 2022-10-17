//
//  UrlImageView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 13.09.2022.
//

import SwiftUI

struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    var defaultImageName: String?

    init(url: URL?, defaultImageName: String? = nil) {
        urlImageModel = UrlImageModel(url: url)
        self.defaultImageName = defaultImageName
    }

    var body: some View {
        if let uiImage = urlImageModel.image {
            Image(uiImage: uiImage)
                .resizable()
        } else if urlImageModel.errorMessage != nil {
            if let defaultImageName = defaultImageName {
                Image(defaultImageName)
                    .resizable()
            } else {
                Image(systemName: "newspaper")
                    .resizable()
            }
        } else {
            ProgressView("Loading...")
        }
    }
}

struct UserAvatarImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel

    init(url: URL?) {
        urlImageModel = UrlImageModel(url: url)
    }

    var body: some View {
        if let uiImage = urlImageModel.image {
            Image(uiImage: uiImage)
                .resizable()
        } else if urlImageModel.errorMessage != nil {
            Image(systemName: "avatar")
                .resizable()
        } else {
            ProgressView()
        }
    }
}
