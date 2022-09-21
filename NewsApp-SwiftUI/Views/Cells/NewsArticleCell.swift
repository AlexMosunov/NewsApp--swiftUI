//
//  NewsArticleCell.swift
//  NewsApp-SwiftUI
//
//  Created by User on 08.09.2022.
//

import SwiftUI

struct NewsArticleCell: View {
    let newsArticle: NewsArticleViewModel
    var rectangleHeight: CGFloat { 150 }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color("ArticleCellRactangle"))
                .frame(height: rectangleHeight, alignment: .bottomTrailing)
                .padding(.init(top: 20, leading: 25, bottom: 0, trailing: -100))
            HStack(alignment: .top) {
                VStack {
                    UrlImageView(url: newsArticle.urlToImage)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 130, height: 130, alignment: .leading)
                        .cornerRadius(20)
                    DateTextView(title: newsArticle.publishedAt)
                        .padding(.top, 2)
                }
                VStack(alignment: .leading) {
                    TitleTextView(
                        title: newsArticle.title,
                        subTitle: newsArticle.description,
                        dateTitle: newsArticle.publishedAt,
                        rectangleHeight: rectangleHeight
                    )
                    .padding(.top, (rectangleHeight / 2) - 130 / 2)
                }
                .padding(.trailing, 5)
            }
        }
    }
}

struct TitleTextView: View {
    let title: String
    let subTitle: String
    let dateTitle: String
    let rectangleHeight: CGFloat
    var titleHeight: CGFloat { 150 }

    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(3)
            Text(subTitle)
                .font(.caption)
                .lineLimit(4)
        }
        .frame(width: UIScreen.main.bounds.size.width - 130 - 5 - 20 - 10 ,height: titleHeight, alignment: .leading)
    }
}

struct DateTextView: View {
    var title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.caption2)
                .foregroundColor(Color(uiColor: .lightGray))
        }
    }
}

struct NewsArticleCell_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleCell(newsArticle: NewsArticleViewModel.default)
    }
}
