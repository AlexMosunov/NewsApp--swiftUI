//
//  NewsSourceListViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import Foundation

@MainActor
class NewsSourceListViewModel: ObservableObject {

    @Published var newsSources: [NewsSourceViewModel] = []

    func getSources() async {
        do {
            let newsSources = try await Webservice().fetchSourcesAsync(url: Constants.Urls.sources)
            try await PersistenceController.shared.saveSources(sources: newsSources)
        } catch {
            print(error)
        }
    }

}

struct NewsSourceViewModel {

    let newsSource: NewsSource?
    let fetchedResult: Source?

    var id: String {
        fetchedResult?.id ?? ""
    }

    var name: String {
        fetchedResult?.name ?? ""
    }

    var description: String {
        fetchedResult?.sourceDescription ?? ""
    }

    static var `default`: NewsSourceViewModel {
        let newsSource = NewsSource(id: "abc-news", name: "ABC News", description: "This is ABC news")
        return NewsSourceViewModel(newsSource: newsSource, fetchedResult: nil)
    }
}
