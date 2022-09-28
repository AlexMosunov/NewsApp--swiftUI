//
//  Constants.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import SwiftUI

struct Constants {

    static let apiKey = "d7ae831b5c654b2bbee290b51935c35b"
    static let limit = 20
    static var page = 1
    @AppStorage("SelectedLanguage") static var selectedLanguage = Languages.en.rawValue
    @AppStorage("SelectedCategory") static var selectedCategory = Categories.allNews.rawValue
    static var maxDaysOld = 5
    static let maxDaysAgoDate = Calendar.current.date(
        byAdding: .day,
        value: -Constants.maxDaysOld,
        to: Date()
    ) ?? Date()
    static var categoryEndpoint: String {
        Constants.selectedCategory.isEmpty ||
        Constants.selectedCategory == Categories.allNews.rawValue ? "" :
        "&category=\(Constants.selectedCategory)"
    }

    struct Urls {
        static func topHeadlines(by source: String) -> URL? {
            return URL(string: "https://newsapi.org/v2/top-headlines?sources=\(source)&apiKey=d7ae831b5c654b2bbee290b51935c35b")
        }
        static let sources: URL? = URL(string: "https://newsapi.org/v2/sources?apiKey=d7ae831b5c654b2bbee290b51935c35b")
        static var topHeadlines: URL? {
            URL(string: "https://newsapi.org/v2/top-headlines?language=\(Constants.selectedLanguage)&page=\(Constants.page)\(Constants.categoryEndpoint)&apiKey=\(Constants.apiKey)")
        }
    }
}
