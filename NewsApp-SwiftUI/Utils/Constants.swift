//
//  Constants.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import Foundation

struct Constants {

    static let apiKey = "d7ae831b5c654b2bbee290b51935c35b"
    static let limit = 20
    static var page = 1
    static var maxDaysOld = 5
    
    struct Urls {
        static func topHeadlines(by source: String) -> URL? {
            return URL(string: "https://newsapi.org/v2/top-headlines?sources=\(source)&apiKey=d7ae831b5c654b2bbee290b51935c35b")
        }
        static let sources: URL? = URL(string: "https://newsapi.org/v2/sources?apiKey=d7ae831b5c654b2bbee290b51935c35b")
        static var topHeadlines: URL? {
            URL(string: "https://newsapi.org/v2/top-headlines?language=en&page=\(Constants.page)&apiKey=\(Constants.apiKey)")
        }
    }
}
