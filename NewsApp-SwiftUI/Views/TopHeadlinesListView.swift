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
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        NavigationView {
            VStack {
                if results.isEmpty {
                    ProgressView()
                        .onAppear {
                            Task {
                                try await refresh()
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
                    .onChange(of: scenePhase) { phase in
                        switch phase {
                        case .active:
                            Task {
                                try await refresh()
                            }
                        default: break
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Top Headlines")
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
