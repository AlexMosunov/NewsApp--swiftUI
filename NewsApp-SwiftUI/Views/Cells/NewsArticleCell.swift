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
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color("ArticleCellRactangle"))
                .frame(height: 130, alignment: .bottomTrailing)
                .padding(.init(top: 30, leading: 25, bottom: 0, trailing: -100))
            HStack(alignment: .top) {
                UrlImageView(url: newsArticle.urlToImage)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 150, maxHeight: 150)
                    .cornerRadius(20)
                VStack {
                    TitleTextView(title: newsArticle.title)
                }
            }
        }
    }
}

struct TitleTextView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .frame(height: 80)
            .padding(.init(top: 75 - 40, leading: 10, bottom: 0, trailing: 0))
    }
}

struct NewsArticleCell_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleCell(newsArticle: NewsArticleViewModel.default)
    }
}
