//
//  HeadlinesList.swift
//  NewsApp-SwiftUI
//
//  Created by User on 27.09.2022.
//

import SwiftUI

struct HeadlinesList: View {
    @FetchRequest var results: FetchedResults<Article>
    @State var showLoading: Bool
    @StateObject var newsArticleListViewModel: NewsArticleListViewModel

    @State var errorText: String?
    @State var showError = false

    init(
        ascendingFilter: Bool,
        showLoading: Bool,
        settingsFilter: SettingsFilter,
        newsArticleListViewModel: NewsArticleListViewModel
    ) {
        _results = Article.datesRangeLanguageTopNewsFetchRequest(
            settingFilter: settingsFilter,
            ascendingFilter: ascendingFilter
        )
        _showLoading = State(initialValue: showLoading)
        _newsArticleListViewModel = StateObject(wrappedValue: newsArticleListViewModel)
    }
    var body: some View {
        ZStack(alignment: .center) {
            List(results.indices, id: \.self) { fetchedArticleIndex in
                if results.isEmpty { ProgressView() }
                let fetchedArticle = results[fetchedArticleIndex]
                let viewModel = NewsArticleViewModel(newsArticle: nil, fetchedResult: fetchedArticle)
                NavigationLink(destination:
                                WebView(url: viewModel.urlToSource,
                                        showLoading: $showLoading)) {
                    NewsArticleCell(newsArticle: viewModel)
                        .onAppear {
                            if fetchedArticleIndex == results.count - 2 {
                                Task {
                                    do {
                                        try await newsArticleListViewModel.loadMore(resultsCount: results.count)
                                    } catch {
                                        errorText = error.localizedDescription
                                        showError.toggle()
                                    }
                                }
                            }
                        }
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
                .listRowBackground(ColorScheme.backgroundColor)
            }
            if results.isEmpty {
                VStack {
                    Text("Loading news...")
                    ProgressView()
                }
                    .onAppear {
                        Task {
                            do {
                                try await newsArticleListViewModel.refresh()
                            } catch {
                                errorText = error.localizedDescription
                                showError.toggle()
                            }
                        }
                    }
            }
        }
        .background(ColorScheme.backgroundColor)
        .alert(isPresented: $showError) {
            Alert(title: Text("Error loading news"),
                  message: Text(errorText ?? ""),
                  dismissButton: .default(Text("Ok")))
        }
    }
}
