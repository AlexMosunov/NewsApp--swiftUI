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
            UrlImageView(url: newsArticle.urlToImage)
                .scaledToFit()
                .frame(maxWidth: 150, maxHeight: 100)
            VStack {
                Text(newsArticle.title)
                    .fontWeight(.bold)
                Text(newsArticle.description)
            }
        }
    }
}

struct NewsArticleCell_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleCell(newsArticle: NewsArticleViewModel.default)
    }
}
