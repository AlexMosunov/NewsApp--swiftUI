//
//  NewsArticleListViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import Foundation
//import CoreData

@MainActor
class NewsArticleListViewModel: ObservableObject {
    
    @Published var newsArticles = [NewsArticleViewModel]()
    
    func getNewsBy(sourceId: String) async {
        do {
            let newsArticles = try await Webservice().fetchNewsAsync(sourceId: sourceId, url: Constants.Urls.topHeadlines(by: sourceId))
            self.newsArticles = newsArticles.map {
                NewsArticleViewModel(newsArticle: $0, fetchedResult: nil)
            }
        } catch {
            print(error)
        }
    }

    func getTopNews() async {
        do {
            let newsArticles = try await Webservice().fetchTopHeadlines(url: Constants.Urls.topHeadlines)
            let loadedArticles = newsArticles.map {
                NewsArticleViewModel(newsArticle: $0, fetchedResult: nil)
            }
            self.newsArticles.append(contentsOf: loadedArticles)
            try await PersistenceController.shared.saveData(articles: newsArticles)
        } catch {
            print(error)
        }
    }

    func loadMore(resultsCount: Int)  async {
        guard Constants.page < 5 else {
            return
        }
        let currentPage = resultsCount / Constants.limit
        Constants.page = currentPage + 1
        Task {
            await getTopNews()
        }
    }
    
}

struct NewsArticleViewModel {
    
    let id = UUID()
    let newsArticle: NewsArticle?
    let fetchedResult: Article?
    
    var title: String {
        newsArticle == nil ? fetchedResult!.title! : newsArticle!.title
    }
    
    var description: String {
        newsArticle == nil ? fetchedResult!.articleDescription ?? "" : newsArticle!.description ?? ""
    }
    
    var author: String {
        newsArticle == nil ? fetchedResult!.author ?? "" : newsArticle!.author ?? ""
    }
     
    var urlToImage: URL? {
        URL(string: (newsArticle == nil ? fetchedResult!.urlToImage : newsArticle!.urlToImage) ?? "https://www.locala.org.uk/assets/images/news-placeholder.png")
    }
    
    var urlToSource: URL? {
        URL(string: newsArticle == nil ? fetchedResult!.url ?? "" : newsArticle!.url ?? "")
    }

    static var `default`: NewsArticleViewModel {
        let newsArticle = NewsArticle(
            author: "author",
            title: "title",
            description: "description",
            url: nil,
            content: "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains.",
            publishedAt: "Yesterday",
            urlToImage: "https://images.app.goo.gl/T4bkEeZTyZhTPgrF7"
        )
        return NewsArticleViewModel(newsArticle: newsArticle, fetchedResult: nil)
    }
    
}
