//
//  CategoriesSeletionView.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 26.09.2022.
//

import SwiftUI

private struct Metrics {
    static var horizontalPadding: CGFloat { 30 }
    static var totalHeight: CGFloat { 50 }
}

struct CategoriesSeletionView: View {
    @Binding var selection: Categories

    var body: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                makeHStack(reader)
            }.frame(height: Metrics.totalHeight)
        }
        .background(ColorScheme.backgroundSecondary)
    }

    private func makeHStack(_ reader: ScrollViewProxy) -> some View {
        LazyHStack(spacing: Metrics.horizontalPadding) {
            ForEach(Categories.allCases, id: \.rawValue) { item in
                let viewModel = CategoryViewModel(
                    selection: $selection,
                    category: item
                )
                CategoryView(viewModel: viewModel)
                    .onTapGesture {
                        withAnimation {
                            reader.scrollTo(item.rawValue, anchor: .center)
                        }
                        viewModel.selectCategory(item)
                    }
            }
        }
        .onAppear(perform: {
            reader.scrollTo(selection.rawValue, anchor: .center)
        })
        .padding([.trailing, .leading], Metrics.horizontalPadding)
    }
}

struct CategoryView: View {

    var viewModel: CategoryViewModel

    var body: some View {
        VStack(spacing: 5) {
            Text(viewModel.categoryName)
                .font(viewModel.font)
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
