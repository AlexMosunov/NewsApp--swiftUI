//
//  CategoriesSeletionView.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 26.09.2022.
//

import SwiftUI

enum Categories: String, CaseIterable {
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
}

struct CategoriesSeletionView: View {
    @State private var selection: Categories = .business

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 30) {
                ForEach(Categories.allCases, id: \.rawValue) { item in
                    CategoryView(category: item, selection: selection)
                        .onTapGesture {
                            selection = item
                        }
                }
            }.padding([.trailing, .leading], 30)
        }
        .frame(height: 50)
    }
}

struct CategoryView: View {
    let category: Categories
    let selection: Categories

    private var foregroundColor: Color {
        category == selection ? Color.gray : Color(uiColor: .label)
    }

    var body: some View {
        VStack {
            Text(category.rawValue.capitalized)
                .font(.title3)
                .foregroundColor(
                    .gray
                )
                .fontWeight(.light)
        }
    }
}

struct CategoriesSeletionView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesSeletionView()
    }
}
