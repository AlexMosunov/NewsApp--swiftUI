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

struct CategoryViewModel {

    @Binding var selection: Categories
    var category: Categories

    func selectCategory(_ item: Categories) {
        selection = item
        Constants.selectedCategory = item.rawValue
    }

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
