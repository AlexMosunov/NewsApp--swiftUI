//
//  NewsArticleCell.swift
//  NewsApp-SwiftUI
//
//  Created by User on 08.09.2022.
//

import SwiftUI

struct NewsArticleCell: View {
    let newsArticle: NewsArticleViewModel

    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: newsArticle.urlToImage) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(maxWidth: 150, maxHeight: 100)
            } placeholder: {
                ProgressView("Loading...")
                    .frame(maxWidth: 150, maxHeight: 100)
            }

            VStack {
                Text(newsArticle.title)
                    .fontWeight(.bold)
                Text(newsArticle.description)
            }
//            if self.islas
        }
    }
}

struct NewsArticleCell_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleCell(newsArticle: NewsArticleViewModel.default)
    }
}
