//
//  Constants.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Constants {

    static let apiKey = "d7ae831b5c654b2bbee290b51935c35b"
    static let limit = 20
    static var page = 1
    @AppStorage("SelectedLanguage") static var selectedLanguage = Languages.en.rawValue
    @AppStorage("SelectedCategory") static var selectedCategory = Categories.allNews.rawValue
    @AppStorage("SelectedCountry") static var selectedCountry = Countries.unselected.rawValue
    @AppStorage("UserId") static var userId: String?
    static var maxDaysOld = 5
    static let maxDaysAgoDate = Calendar.current.date(
        byAdding: .day,
        value: -Constants.maxDaysOld,
        to: Date()
    ) ?? Date()
    static var languageEndpoint: String {
        Constants.selectedLanguage.isEmpty ||
        Constants.selectedLanguage == Languages.unselected.rawValue ? "" :
        "&language=\(Constants.selectedLanguage)"
    }
    static var categoryEndpoint: String {
        Constants.selectedCategory.isEmpty ||
        Constants.selectedCategory == Categories.allNews.rawValue ? "" :
        "&category=\(Constants.selectedCategory)"
    }
    static var countryEndpoint: String {
        Constants.selectedCountry.isEmpty ||
        Constants.selectedCountry == Countries.unselected.rawValue ? "" :
        "&country=\(Constants.selectedCountry)"
    }

    struct Urls {
        static func topHeadlines(by source: String) -> URL? {
            return URL(string: "https://newsapi.org/v2/top-headlines?sources=\(source)&apiKey=\(Constants.apiKey)")
        }
        static let sources: URL? = URL(string: "https://newsapi.org/v2/sources?apiKey=\(Constants.apiKey)")
        static var topHeadlines: URL? {
            URL(string: "https://newsapi.org/v2/top-headlines?page=\(Constants.page)\(Constants.languageEndpoint)\(Constants.categoryEndpoint)\(Constants.countryEndpoint)&apiKey=\(Constants.apiKey)")
        }
    }
}

let COLLECTION_USERS = Firestore.firestore().collection("users")
