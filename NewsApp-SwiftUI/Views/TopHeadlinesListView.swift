//
//  TopHeadlinesListView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.09.2022.
//

import SwiftUI

struct TopHeadlinesListView: View {
    @StateObject private var newsArticleListViewModel = NewsArticleListViewModel()
    @State private var showLoading: Bool = false
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Article.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Article.publishedAt, ascending: true)]) var results : FetchedResults<Article>

    var body: some View {
        NavigationView {
            VStack {
                if results.isEmpty {
                    if newsArticleListViewModel.newsArticles.isEmpty {
                        ProgressView()
                            .onAppear {
                                Task {
                                    await newsArticleListViewModel.getTopNews()
                                }
                            }
                    } else {
                        List(newsArticleListViewModel.newsArticles, id: \.id) { newsArticle in
                            NavigationLink(destination:
                                            WebView(url: newsArticle.urlToSource!,
                                                    showLoading: $showLoading)) {
                                NewsArticleCell(newsArticle: newsArticle)
                            }
                        }
                    }
                } else {
                    List(results) { fetchedArticle in
                        let viewModel = NewsArticleViewModel(newsArticle: nil, fetchedResult: fetchedArticle)
                        NavigationLink(destination:
                                        WebView(url: viewModel.urlToSource!,
                                                showLoading: $showLoading)) {
                            NewsArticleCell(newsArticle: viewModel)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle( results.isEmpty ? "Top Headlines" : "Top fetched headlines")
            .refreshable {
                Task {
                    try await refresh()
                }
            }
        }
    }

    private func refresh() async throws {
        do {
            results.forEach { video in
                context.delete(video)
            }
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        newsArticleListViewModel.newsArticles.removeAll()
    }
}

struct TopHeadlinesListView_Previews: PreviewProvider {
    static var previews: some View {
        TopHeadlinesListView()
    }
}
