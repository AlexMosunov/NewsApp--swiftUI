//
//  FavouriteArticleCell.swift
//  NewsApp-SwiftUI
//
//  Created by User on 03.10.2022.
//

import SwiftUI
private struct CellMetrics {
    static var itemWidth: CGFloat { 300 }
    static var itemHeight: CGFloat { 150 }
}

struct FavouriteArticleCell: View {
    let newsArticle: NewsArticleViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            UrlImageView(url: newsArticle.urlToImage)
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: 300,
                    height: 150,
                    alignment: .bottom
                )
                .cornerRadius(12)
            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                .frame(
                    width: 300,
                    height: 150,
                    alignment: .bottom
                )
                .cornerRadius(12)
            Text(newsArticle.title)
                .foregroundColor(.white)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
                .padding()
                .frame(
                    width: 300,
                    alignment: .bottom
                )
            Text(newsArticle.publishedAt)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(alignment: .topLeading)
        }
        .contextMenu {
            Button {
                Task {
                    await newsArticle.toggleFavourite()
                }
            } label: {
                Label(newsArticle.favouritesTitle, systemImage: newsArticle.favouritesIconName)
            }
        }
        .id(newsArticle.id)
    }
}

struct FavouriteArticleCell_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteArticleCell(newsArticle: .default)
    }
}
