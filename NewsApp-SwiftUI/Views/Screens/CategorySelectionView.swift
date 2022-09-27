//
//  CategoriesSeletionView.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 26.09.2022.
//

import SwiftUI

fileprivate struct Metrics {
    static var labelFont: Font { .title3 }
}

struct CategoriesSeletionView: View {
    @Binding var selection: Categories

    var body: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 30) {
                    ForEach(Categories.allCases, id: \.rawValue) { item in
                        CategoryView(
                            viewModel: .init(selection: $selection, category: item)
                        )
                        .onTapGesture {
                            withAnimation {
                                reader.scrollTo(item.rawValue, anchor: .center)
                            }
                            selection = item
                            Constants.selectedCategory = item.rawValue
                        }
                    }
                }
                .onAppear(perform: {
                    reader.scrollTo(selection.rawValue, anchor: .center)
                })
                .padding([.trailing, .leading], 30)
            }.frame(height: 50)
        }
        .background(ColorScheme.backgroundSecondary)
    }
}

struct CategoryView: View {

    var viewModel: CategoryViewModel

    var body: some View {
        VStack(spacing: 5) {
            Text(viewModel.categoryString)
                .font(.title3)
                .foregroundColor(viewModel.foregroundColor)
                .fontWeight(viewModel.fontWeight)
            Rectangle()
                .fill(viewModel.dividerColor)
                .frame(
                    width: viewModel.dividerWidth,
                    height: 3,
                    alignment: .center
                )
        }
    }
}

struct CategoriesSeletionView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesSeletionView(selection: .constant(.business))
    }
}
