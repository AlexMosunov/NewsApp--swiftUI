//
//  TopHeadlinesListView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.09.2022.
//

import SwiftUI
import CoreData

struct SettingsFilter: Equatable {
    var fromDate: Date
    var toDate: Date
    var language: String
    var selection: Categories
}

struct TopHeadlinesListScreen: View {
    @StateObject private var newsArticleListViewModel = NewsArticleListViewModel()
    @State private var showLoading: Bool = false
    @State private var ascendingSort: Bool = false
    @State var showSettings: Bool = false
    @State var settingsFilter: SettingsFilter = SettingsFilter(
        fromDate: Constants.maxDaysAgoDate,
        toDate: Date(),
        language: Constants.selectedLanguage,
        selection: Categories(string: Constants.selectedCategory) ?? .business
    )
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        NavigationView {
            VStack {
                CategoriesSeletionView(selection: $settingsFilter.selection)
                    .frame(height: 50, alignment: .top)
                HeadlinesList(ascendingFilter: ascendingSort,
                              showLoading: showLoading,
                              settingsFilter: settingsFilter,
                              newsArticleListViewModel: newsArticleListViewModel)
            }
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    Task {
                        await newsArticleListViewModel.refresh()
                    }
                default: break
                }
            }
            .listStyle(.plain)
            .navigationTitle("Top Headlines")
            .background(Color("ArticleCellBG"))
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
                await newsArticleListViewModel.refresh()
            }
        }
        .sheet(isPresented: $showSettings) {
            Constants.selectedLanguage = settingsFilter.language
            Task {
                await newsArticleListViewModel.refresh()
            }
        } content: {
            SettingsScreen(settingsFilter: $settingsFilter)
        }

    }

}

struct HeadlinesList: View {
    @FetchRequest var results: FetchedResults<Article>
    @State var showLoading: Bool
    @StateObject var newsArticleListViewModel: NewsArticleListViewModel

    init(
        ascendingFilter: Bool,
        showLoading: Bool,
        settingsFilter: SettingsFilter,
        newsArticleListViewModel: NewsArticleListViewModel
    ) {
        _results = Article.datesRangeLanguageTopNewsFetchRequest(
            fromDate: settingsFilter.fromDate,
            toDate: settingsFilter.toDate,
            language: settingsFilter.language,
            category: settingsFilter.selection.rawValue,
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
            if results.isEmpty {
                ProgressView()
                    .onAppear {
                        Task {
                            await newsArticleListViewModel.refresh()
                        }
                    }
            }
        }
    }
}

struct TopHeadlinesListView_Previews: PreviewProvider {
    static var previews: some View {
        TopHeadlinesListScreen()
    }
}
