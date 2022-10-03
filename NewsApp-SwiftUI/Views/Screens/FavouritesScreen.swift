//
//  FavouritesScreen.swift
//  NewsApp-SwiftUI
//
//  Created by User on 03.10.2022.
//

import SwiftUI
import CoreData

struct FavouritesScreen: View {
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(Categories.allCases, id: \.rawValue) { item in
                    FavouriteCategoryStackView(category: item)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .background(ColorScheme.backgroundSecondary)
            .navigationTitle("Favourites")
        }
    }
}

struct FavouriteCategoryStackView: View {
    @FetchRequest var results: FetchedResults<Article>
    let categoryName: LocalizedStringKey
    @State private var showLoading: Bool = false

    init(category: Categories) {
        _results = Article.favouritesWithCategoriesRequest(category: category)
        let str = "category_\(category.rawValue)"
        self.categoryName = LocalizedStringKey(str)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if results.isEmpty == false {
                Text(categoryName)
                    .font(.headline)
                    .padding(.leading, 20)
            }
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHStack(spacing: 20) {
                    ForEach(results) { article in
                        let vm = NewsArticleViewModel(newsArticle: nil, fetchedResult: article)
                        NavigationLink {
                            if showLoading {
                                ProgressView()
                            }
                            WebView(url: vm.urlToSource,
                                        showLoading: $showLoading)
                        } label: {
                            FavouriteArticleCell(newsArticle: vm)
                        }
                    }
                }
                .padding([.trailing, .leading], 20)
            }
        }
    }
}

struct FavouritesScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesScreen()
    }
}
