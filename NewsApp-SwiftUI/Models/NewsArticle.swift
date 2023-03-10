//
//  NewsArticle.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import Foundation

struct NewsArticleResponse: Decodable {
    let articles: [NewsArticle]
}

struct NewsArticle: Decodable {
    let source: NewsSource?
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let content: String?
    let publishedAt: String
    let urlToImage: String?
}
