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
            TopHeadlinesListView()
                .tabItem {
                    Text("Top News")
                }
            NewsSourceListScreen()
                .tabItem {
                    Text("Sources")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
