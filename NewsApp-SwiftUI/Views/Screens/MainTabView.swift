//
//  MainTabView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.09.2022.
//

import SwiftUI

struct MainTabView: View {
    var currentUserID: String?
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TabView {
                    TopHeadlinesListScreen()
                        .tabItem {
                            Label(
                                Localized.tabview_headlines,
                                systemImage: "globe.europe.africa"
                            )
                        }
                    NewsSourceListScreen()
                        .tabItem {
                            Label(
                                Localized.tabview_sources,
                                systemImage: "list.bullet.circle"
                            )
                        }
                    FavouritesScreen()
                        .tabItem {
                            Label(
                                Localized.tabview_favourites,
                                systemImage: "bookmark.circle.fill"
                            )
                        }
                    SearchScreen()
                        .tabItem {
                            Label(
                                Localized.tabview_search,
                                systemImage: "magnifyingglass"
                            )
                        }
                    ProfileScreen()
                        .tabItem {
                            Label(
                                Localized.tabview_profile,
                                systemImage: "person.fill"
                            )
                        }
                }
                .accentColor(.orange)
                .background(ColorScheme.backgroundColor)
            } else {
                SignInScreen()
            }
        }

    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
