//
//  NewsSource.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import Foundation

struct NewsSourceResponse: Decodable {
    let sources: [NewsSource]
}

struct NewsSource: Decodable {
    let id: String?
    let name: String?
    let description: String?
}
