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
    var language: Languages
    var selection: Categories
    var country: Countries
}

struct TopHeadlinesListScreen: View {
    @StateObject private var newsArticleListViewModel = NewsArticleListViewModel()
    @State private var showLoading: Bool = false
    @State private var ascendingSort: Bool = false
    @State var showSettings: Bool = false
    @State var settingsFilter: SettingsFilter = SettingsFilter(
        fromDate: Constants.maxDaysAgoDate,
        toDate: Date(),
        language: Languages(rawValue: Constants.selectedLanguage) ?? .en,
        selection: Categories(rawValue: Constants.selectedCategory) ?? .business,
        country: Countries(rawValue: Constants.selectedCountry) ?? .unselected
    )
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        NavigationView {
            VStack {
                HeadlinesList(ascendingFilter: ascendingSort,
                              showLoading: showLoading,
                              settingsFilter: settingsFilter,
                              newsArticleListViewModel: newsArticleListViewModel)
                CategoriesSeletionView(selection: $settingsFilter.selection)
                    .frame(height: 50, alignment: .top)
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
            .navigationTitle(Localized.headlines_title)
            .background(ColorScheme.backgroundColor)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .tint(.orange)
                    }
                    Button {
                        ascendingSort.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .rotationEffect(.radians(ascendingSort ? .pi : .zero))
                            .tint(.orange)
                    }
                }
            }
            .refreshable {
                await newsArticleListViewModel.refresh()
            }
        }
        .sheet(isPresented: $showSettings) {
            Constants.selectedLanguage = settingsFilter.language.rawValue // TODO: change
            Constants.selectedCountry = settingsFilter.country.rawValue
            Task {
                await newsArticleListViewModel.refresh()
            }
        } content: {
            SettingsScreen(settingsFilter: $settingsFilter)
        }
    }

}

struct TopHeadlinesListView_Previews: PreviewProvider {
    static var previews: some View {
        TopHeadlinesListScreen()
    }
}
