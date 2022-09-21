//
//  NewsArticleCell.swift
//  NewsApp-SwiftUI
//
//  Created by User on 08.09.2022.
//

import SwiftUI

fileprivate struct CellMetrics {
    static var rectangleHeight: CGFloat { 150 }
    static var titleHeight: CGFloat { 145 }
    static var imageHeight: CGFloat { 130 }
    static var titleTopPadding: CGFloat { 5 + (rectangleHeight / 2) - imageHeight / 2 }
    static var roundedShapePadding: EdgeInsets {.init(top: 20, leading: 25, bottom: 0, trailing: 0)}
    static var trailingCellInset: CGFloat { 5 }
}

struct NewsArticleCell: View {
    let newsArticle: NewsArticleViewModel

    var body: some View {
        ZStack {
            RoundedCornersShapeView()
            HStack(alignment: .top) {
                VStack {
                    UrlImageView(url: newsArticle.urlToImage)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: CellMetrics.imageHeight, height: CellMetrics.imageHeight, alignment: .leading)
                        .cornerRadius(20)
                    DateTextView(title: newsArticle.publishedAt)
                        .padding(.top, 2)
                }
                VStack(alignment: .leading) {
                    TitleTextView(
                        title: newsArticle.title,
                        subTitle: newsArticle.description
                    )
                    .padding(.top, CellMetrics.titleTopPadding)
                }
                .padding(.trailing, CellMetrics.trailingCellInset)
            }
        }
    }
}

struct RoundedCornersShapeView: View {
    var body: some View {
        RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: 20)
            .fill(Color("ArticleCellRactangle"))
            .frame(height: CellMetrics.rectangleHeight, alignment: .bottomTrailing)
            .padding(CellMetrics.roundedShapePadding)
    }
}

struct TitleTextView: View {
    let title: String
    let subTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(3)
            Text(subTitle)
                .font(.caption)
                .lineLimit(4)
        }
        .frame(
            width: UIScreen.main.bounds.size.width -
                   CellMetrics.imageHeight -
                   CellMetrics.trailingCellInset - 20 - 10 ,
            height: CellMetrics.titleHeight,
            alignment: .leading
        )
    }
}

struct DateTextView: View {
    var title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct NewsArticleCell_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleCell(newsArticle: NewsArticleViewModel.default)
    }
}
