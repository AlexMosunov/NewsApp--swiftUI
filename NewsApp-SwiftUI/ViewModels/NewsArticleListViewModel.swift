//
//  NewsArticleListViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import Foundation
import SwiftUI

@MainActor
class NewsArticleListViewModel: ObservableObject {

    @Published var newsArticles = [NewsArticleViewModel]()

    func getNewsBy(sourceId: String) async throws {
        let newsArticles = try await Webservice().fetchNewsAsync(sourceId: sourceId, url: Constants.Urls.topHeadlines(by: sourceId))
        try await PersistenceController.shared.saveData(articles: newsArticles, sourceId: sourceId)
    }

    func getTopNews() async throws {
        let newsArticles = try await Webservice().fetchTopHeadlines(url: Constants.Urls.topHeadlines)
        try await PersistenceController.shared.saveData(articles: newsArticles, sourceId: nil)
    }

    func loadMore(resultsCount: Int)  async throws {
        let currentPage = resultsCount / Constants.limit
        Constants.page = currentPage + 1
        guard Constants.page <= 5 else {
            Constants.page = 6
            return
        }
        Task {
            try await getTopNews()
        }
    }

    func refresh() async throws {
        Constants.page = 1
        try await getTopNews()
    }
}

struct NewsArticleViewModel {

    let id = UUID()
    let newsArticle: NewsArticle?
    let fetchedResult: Article?

    var title: String {
        fetchedResult?.title ?? ""
    }

    var description: String {
        fetchedResult?.articleDescription ?? ""
    }

    var author: String {
        fetchedResult?.author ?? ""
    }

    var publishedAt: String {
        fetchedResult?.publishedAt?.toDate()?.timeAgoDisplay() ?? ""
    }

    var urlToImage: URL? {
        URL(string: fetchedResult?.urlToImage ?? "https://www.locala.org.uk/assets/images/news-placeholder.png")
    }

    var urlToSource: URL {
        URL(string: fetchedResult?.url ?? "") ??
        URL(string: "https://www.publicdomainpictures.net/pictures/280000/velka/not-found-image-15383864787lu.jpg")!
    }

    var isFavourite: Bool {
        fetchedResult?.isFavourite ?? false
    }

    var favouritesTitle: LocalizedStringKey {
        isFavourite ? Localized.article_favourite_remove : Localized.article_favourite_add
    }

    var favouritesIconName: String {
        isFavourite ? "bookmark.fill" : "bookmark"
    }

    func toggleFavourite() async {
        do {
            try await PersistenceController.shared.toggleArticleFavourite(fetchedResult)
        } catch {
            print(error)
        }
    }

    static var `default`: NewsArticleViewModel {
        let newsArticle = NewsArticle(
            source: nil,
            author: "BBC News",
            title: "Little Mermaid: Halle Bailey in awe of children's reaction to Disney trailer",
            description: "Halle Bailey says children's joy at the sight of a non-white Disney star \"means the world to me\".",
            url: nil,
            content: "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains.",
            publishedAt: "2022-09-14T19:52:21.4676017Z",
            urlToImage: "https://ichef.bbci.co.uk/news/1024/branded_news/155E/production/_126707450_gettyimages-1422381162.jpg"
        )
        return NewsArticleViewModel(newsArticle: newsArticle, fetchedResult: PersistenceController.shared.getRandomArticle())
    }

}
