//
//  NewsListScreen.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import SwiftUI

struct NewsListScreen: View {

    let newsSource: NewsSourceViewModel
    @StateObject private var newsArticleListViewModel = NewsArticleListViewModel()
    @State private var showLoading: Bool = false
    
    var body: some View {
        List(newsArticleListViewModel.newsArticles, id: \.id) { newsArticle in
            NavigationLink(destination:
                            WebView(url: newsArticle.urlToSource!,
                                    showLoading: $showLoading)
                            .overlay(showLoading ?
                                     ProgressView("Loading...").toAnyView() :
                                     EmptyView().toAnyView()) ) {
                NewsArticleCell(newsArticle: newsArticle)
            }
        }
        .listStyle(.plain)
        .onAppear {
            Task {
                await newsArticleListViewModel.getNewsBy(sourceId: newsSource.id)
            }
        }
        .navigationTitle(newsSource.name)
        .navigationBarItems(trailing: Button(action: {
            Task {
                await newsArticleListViewModel.getNewsBy(sourceId: newsSource.id)
            }
        }, label: {
            Image(systemName: "arrow.clockwise.circle")
        }))
    }
}

struct NewsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewsListScreen(newsSource: NewsSourceViewModel.default)
    }
}
