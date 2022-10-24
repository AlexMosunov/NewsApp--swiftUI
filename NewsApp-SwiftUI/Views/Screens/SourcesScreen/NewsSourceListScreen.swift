//
//  NewsSourceListScreen.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import SwiftUI
import CoreData

struct NewsSourceListScreen: View {

    @StateObject private var newsSourceListViewModel = NewsSourceListViewModel()
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.id, order: SortOrder.forward)
        ]
    ) var results: FetchedResults<Source>

    var body: some View {
        NavigationView {
            if results.isEmpty {
                ProgressView()
                    .task({
                        await newsSourceListViewModel.getSources()
                    })
            } else {
                List(results) { fetchedSource in
                    let viewModel = NewsSourceViewModel(newsSource: nil, fetchedResult: fetchedSource)
                    NavigationLink(destination: NewsListScreen(newsSource: viewModel)) {
                        NewsSourceCell(newsSource: viewModel)
                    }
                    .listRowBackground(ColorScheme.backgroundSecondary)
                }
                .background(ColorScheme.backgroundSecondary)
                .listStyle(.plain)
                .navigationTitle(Localized.sources_title)
            }
        }
        .refreshable {
            await newsSourceListViewModel.getSources()
        }
    }
}

struct NewsSourceListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewsSourceListScreen()
    }
}

struct NewsSourceCell: View {

    let newsSource: NewsSourceViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(newsSource.name)
                .font(.headline)
            Text(newsSource.description)
        }
    }
}
