//
//  CategoriesSeletionViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by User on 26.09.2022.
//

import SwiftUI

enum Categories: String, CaseIterable {
    case allNews = "all news"
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
}

extension Categories {
    init?(string: String) {
        switch string.lowercased() {
        case "all news": self = .allNews
        case "business": self = .business
        case "entertainment": self = .entertainment
        case "general": self = .general
        case "health": self = .health
        case "science": self = .science
        case "sports": self = .sports
        case "technology": self = .technology
        default: return nil
        }
    }
}

struct CategoryViewModel {

    @Binding var selection: Categories
    var category: Categories

    var categoryString: String {
        category.rawValue.capitalized
    }

    var foregroundColor: Color {
        category == selection ? Color(uiColor: .label) : Color.gray
    }

    var fontWeight: Font.Weight {
        category == selection ? .medium : .light
    }

    var dividerWidth: CGFloat {
        category.rawValue.widthOfString(
            usingFont: UIFont.preferredFont(forTextStyle: .title3)
        )
    }

    var dividerColor: Color {
        category == selection ? .orange : .clear
    }

}
