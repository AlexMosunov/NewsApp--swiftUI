//
//  NewsArticleCell.swift
//  NewsApp-SwiftUI
//
//  Created by User on 08.09.2022.
//

import SwiftUI

private struct CellMetrics {
    static var rectangleHeight: CGFloat { 150 }
    static var titleHeight: CGFloat { 145 }
    static var imageHeight: CGFloat { 130 }
    static var titleTopPadding: CGFloat { 5 + (rectangleHeight / 2) - imageHeight / 2 }
    static var roundedShapePadding: EdgeInsets {.init(top: 20, leading: 25, bottom: 0, trailing: 0)}
    static var trailingCellInset: CGFloat { 5 }
    static var horizontalParentPadding: CGFloat { 30 }
    static var titleTextWidth: CGFloat {
        UIScreen.main.bounds.size.width -
        imageHeight -
        trailingCellInset -
        horizontalParentPadding
    }
}

// 2. Share Text
struct ShareText: Identifiable {
    let id = UUID()
    let text: String
}

struct NewsArticleCell: View {
    let newsArticle: NewsArticleViewModel
    @State var shareText: ShareText?

    var body: some View {
        ZStack {
            RoundedCornersShapeView()
            HStack(alignment: .top) {
                ImageStackView(newsArticle)
                TextStackView(newsArticle)
            }
        }
        .sheet(item: $shareText) { shareText in
            ActivityView(text: shareText.text)
        }
        .contextMenu {
            Button {
                Task {
                    await newsArticle.toggleFavourite()
                }
            } label: {
                Label(newsArticle.favouritesTitle, systemImage: newsArticle.favouritesIconName)
            }
            Button {
                shareText = ShareText(text: "Check out this article that I found on my news app! - " + newsArticle.title + " " + newsArticle.urlToSource.absoluteString)
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
        .id(newsArticle.id)
    }
}

struct ImageStackView: View {
    let newsArticle: NewsArticleViewModel

    init(_ newsArticle: NewsArticleViewModel) {
        self.newsArticle = newsArticle
    }

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                UrlImageView(url: newsArticle.urlToImage)
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: CellMetrics.imageHeight,
                        height: CellMetrics.imageHeight,
                        alignment: .center
                    )
                    .cornerRadius(20)
                if newsArticle.isFavourite {
                    Image(systemName: "bookmark.circle")
                        .frame(width: 15, height: 15)
                        .padding(10)
                        .foregroundColor(.orange)
                }
            }
            DateTextView(title: newsArticle.publishedAt)
                .padding(.top, 6)
        }
    }
}

struct TextStackView: View {
    let newsArticle: NewsArticleViewModel

    init(_ newsArticle: NewsArticleViewModel) {
        self.newsArticle = newsArticle
    }

    var body: some View {
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

struct RoundedCornersShapeView: View {
    var body: some View {
        RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: 20)
            .fill(ColorScheme.backgroundSecondary)
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
                   CellMetrics.trailingCellInset -
                   CellMetrics.horizontalParentPadding,
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

// 1. Activity View
struct ActivityView: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}

struct NewsArticleCell_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleCell(newsArticle: NewsArticleViewModel.default)
    }
}
