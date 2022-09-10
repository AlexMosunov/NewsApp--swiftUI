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
    @FetchRequest(entity: Article.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Article.publishedAt, ascending: false)]) var results : FetchedResults<Article>

    var body: some View {
        NavigationView {
            VStack {
                if results.isEmpty {
                    ProgressView()
                        .onAppear {
                            Task {
                                await newsArticleListViewModel.getTopNews()
                            }
                        }
                } else {
                    List(results.indices, id: \.self) { fetchedArticleIndex in
                        let fetchedArticle = results[fetchedArticleIndex]
                        let viewModel = NewsArticleViewModel(newsArticle: nil, fetchedResult: fetchedArticle)
                        NavigationLink(destination:
                                        WebView(url: viewModel.urlToSource!,
                                                showLoading: $showLoading)) {
                            NewsArticleCell(newsArticle: viewModel)
                                .onAppear {
                                    if fetchedArticleIndex == results.count - 2 {
                                        Task {
                                            await newsArticleListViewModel.loadMore(resultsCount: results.count)
                                        }
                                    }
                                }
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
        Constants.page = 1
        Task {
            await newsArticleListViewModel.getTopNews()
        }
    }
}

struct TopHeadlinesListView_Previews: PreviewProvider {
    static var previews: some View {
        TopHeadlinesListView()
    }
}
