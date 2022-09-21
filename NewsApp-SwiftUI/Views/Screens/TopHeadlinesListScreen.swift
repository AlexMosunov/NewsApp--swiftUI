//
//  TopHeadlinesListView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.09.2022.
//

import SwiftUI

struct TopHeadlinesListScreen: View {
    @StateObject private var newsArticleListViewModel = NewsArticleListViewModel()
    @State private var showLoading: Bool = false
    @State private var ascendingSort: Bool = false
    @State var showSettings: Bool = false
    @State var fromDate = Constants.maxDaysAgoDate
    @State var toDate = Date()
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        NavigationView {
            HeadlinesList(ascendingFilter: ascendingSort,
                          showLoading: showLoading,
                          fromDate: fromDate,
                          toDate: toDate,
                          newsArticleListViewModel: newsArticleListViewModel)
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    Task {
                        await refresh()
                    }
                default: break
                }
            }
            .listStyle(.plain)
            .navigationTitle("Top Headlines")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Settings") {
                        showSettings.toggle()
                    }
                    Button {
                        ascendingSort.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .rotationEffect(.radians(ascendingSort ? .pi : .zero))
                    }
                }
            }
            .refreshable {
                await refresh()
            }
        }
        .sheet(isPresented: $showSettings, content: {
            SettingsScreen(fromDate: $fromDate, toDate: $toDate)
        })
    }

    private func refresh() async {
        Constants.page = 1
        await newsArticleListViewModel.getTopNews()
    }
}

struct HeadlinesList: View {
    @FetchRequest var results: FetchedResults<Article>
    @State var showLoading: Bool
    @StateObject var newsArticleListViewModel: NewsArticleListViewModel

    init(
        ascendingFilter: Bool,
        showLoading: Bool,
        fromDate: Date,
        toDate: Date,
        newsArticleListViewModel: NewsArticleListViewModel
    ) {
        _results = Article.datesRangeTopNewsFetchRequest(fromDate: fromDate, toDate: toDate, ascendingFilter: ascendingFilter)
        _showLoading = State(initialValue: showLoading)
        _newsArticleListViewModel = StateObject(wrappedValue: newsArticleListViewModel)
    }
    var body: some View {
        if results.isEmpty {
            ProgressView()
        } else {
            List(results.indices, id: \.self) { fetchedArticleIndex in
                let fetchedArticle = results[fetchedArticleIndex]
                let viewModel = NewsArticleViewModel(newsArticle: nil, fetchedResult: fetchedArticle)
                NavigationLink(destination:
                                WebView(url: viewModel.urlToSource,
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
                .listStyle(.plain)
                .listRowSeparator(.hidden)
                .listRowBackground(Color("ArticleCellBG"))
            }
            .background(Color("ArticleCellBG"))
        }
    }
}

struct TopHeadlinesListView_Previews: PreviewProvider {
    static var previews: some View {
        TopHeadlinesListScreen()
    }
}
