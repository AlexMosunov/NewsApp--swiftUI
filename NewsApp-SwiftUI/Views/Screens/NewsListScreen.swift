//
//  NewsListScreen.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import SwiftUI

struct NewsListScreen: View {
    var newsSource: NewsSourceViewModel
    @StateObject private var newsArticleListViewModel = NewsArticleListViewModel()
    @State private var showLoading: Bool = false
    @FetchRequest var results: FetchedResults<Article>

    init(newsSource: NewsSourceViewModel) {
        self.newsSource = newsSource
        _results = FetchRequest(
            entity: Article.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Article.publishedAt, ascending: false)],
            predicate: NSPredicate(format: "sourceId == %@", newsSource.id))
    }

    var body: some View {
        List(results) { fetchedArticle in
            let viewModel = NewsArticleViewModel(newsArticle: nil, fetchedResult: fetchedArticle)
            NavigationLink(destination:
                            WebView(url: viewModel.urlToSource,
                                    showLoading: $showLoading) ) {
                NewsArticleCell(newsArticle: viewModel)
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .listRowBackground(ColorScheme.backgroundColor)
        }
        .listStyle(.plain)
        .background(ColorScheme.backgroundColor)
        .onAppear {
            Task {
                await newsArticleListViewModel.getNewsBy(sourceId: newsSource.id)
            }
        }
        .refreshable {
            await newsArticleListViewModel.getNewsBy(sourceId: newsSource.id)
        }
        .navigationTitle(newsSource.name)
    }
}

struct NewsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewsListScreen(newsSource: NewsSourceViewModel.default)
    }
}
