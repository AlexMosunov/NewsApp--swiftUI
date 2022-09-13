//
//  UrlImageView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 13.09.2022.
//

import SwiftUI

struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    
    init(url: URL?) {
        urlImageModel = UrlImageModel(url: url)
    }
    
    var body: some View {
        if let uiImage = urlImageModel.image {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            ProgressView("Loading...")
        }
    }
}
