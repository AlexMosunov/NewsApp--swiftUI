//
//  MainTabView.swift
//  NewsApp-SwiftUI
//
//  Created by User on 07.09.2022.
//

import SwiftUI

struct MainTabView: View {
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        TabView {
            TopHeadlinesListView()
                .tabItem {
                    Text("Top News")
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
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
