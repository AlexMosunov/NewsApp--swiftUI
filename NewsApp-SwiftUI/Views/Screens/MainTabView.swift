//
//  MainTabView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.09.2022.
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
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
        }
        .accentColor(.orange)
        .background(ColorScheme.backgroundColor)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
