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
                    Label("Top News", systemImage: "globe.europe.africa")
                }
            NewsSourceListScreen()
                .tabItem {
                    Label("Sources", systemImage: "list.bullet.circle")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
