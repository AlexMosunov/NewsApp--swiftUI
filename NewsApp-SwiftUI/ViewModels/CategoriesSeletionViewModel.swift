//
//  CategoriesSeletionViewModel.swift
//  NewsApp-SwiftUI
//
//  Created by User on 26.09.2022.
//

import SwiftUI

enum SupportedLanguages: String, CaseIterable {
    case en
    case uk
}

enum Categories: String, CaseIterable {
    case allNews
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}

struct CategoryViewModel {

    @Binding var selection: Categories
    var category: Categories

    func selectCategory(_ item: Categories) {
        selection = item
        Constants.selectedCategory = item.rawValue
    }

    var categoryName: LocalizedStringKey {
        let str = "category_\(category.rawValue)"
        return LocalizedStringKey(str)
    }

    var foregroundColor: Color {
        category == selection ? Color(uiColor: .label) : Color.gray
    }

    var fontWeight: Font.Weight {
        category == selection ? .medium : .light
    }

    var dividerWidth: CGFloat {
        categoryName.width(
            usingFont: UIFont.preferredFont(forTextStyle: .title3)
        ) ?? 0
    }

    var dividerColor: Color {
        category == selection ? .orange : .clear
    }

}
