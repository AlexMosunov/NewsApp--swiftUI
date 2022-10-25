//
//  SearchScreen.swift
//  NewsApp-SwiftUI
//
//  Created by User on 19.10.2022.
//

import SwiftUI
import AVFoundation
import CoreData

enum SortingOrders: String, CaseIterable {
    case relevancy
    case popularity
    case publishedAt
}

struct SearchScreen: View {
    @StateObject var debounceObject = DebounceObject(dueTime: 1.0)
    @State var order: SortingOrders = .publishedAt
    @StateObject private var newsArticleListViewModel = NewsArticleListViewModel()
    @Environment(\.dismissSearch) var dismissSearch
    @FetchRequest(
        entity: RecentSearch.entity(),
        sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    var recentSearches: FetchedResults<RecentSearch>

    @State var errorText: String?
    @State var showError = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .center, spacing: 15) {
                    Picker("", selection: $order) {
                        ForEach(SortingOrders.allCases, id: \.rawValue) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: order) { _ in
                        loadNews()
                    }
                    if newsArticleListViewModel.newsArticlesViewModel.isEmpty || debounceObject.debouncedText.isEmpty {
                            Text("Enter your search query to load articles")
                            List(recentSearches) { search in
                                if let query = search.query, !query.isEmpty {
                                    Button {
                                        debounceObject.showLoading = true
                                        debounceObject.text = query
                                        print("DEBUG: query - \(query)")
                                    } label: {
                                        Text(query)
                                    }
                                }
                            }
                            .listStyle(.plain)
                    } else {
                        List(newsArticleListViewModel.newsArticlesViewModel, id: \.id) { article in
                            NavigationLink(destination:
                                            WebView(url: article.urlToSource,
                                                    showLoading: $debounceObject.showLoading)) {
                                NewsArticleCell(newsArticle: article)
                            }
                        }
                        .simultaneousGesture(DragGesture().onChanged({ _ in
                            dismissSearch()
                            hideKeyboard()
                        }))
                        .listStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowBackground(ColorScheme.backgroundColor)
                    }
                }
                if debounceObject.showLoading {
                    ProgressView("LOADING...")
                }
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error loading news"),
                  message: Text(errorText ?? ""),
                  dismissButton: .default(Text("Ok")))
        }
        .searchable(text: $debounceObject.text, prompt: "Find news")
        .onChange(of: debounceObject.debouncedText) { _ in
            loadNews()
        }
    }

    private func loadNews() {
        guard !debounceObject.debouncedText.isEmpty else {
            return
        }
        debounceObject.showLoading = true
        Task {
            do {
                try await self.newsArticleListViewModel.searchArticlesWith(
                    query: debounceObject.debouncedText,
                    order: order
                )
                try await PersistenceController.shared.createRecentSearch(with: debounceObject.debouncedText)
            } catch {
                errorText = error.localizedDescription
                showError.toggle()
            }
            debounceObject.showLoading = false
        }
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}