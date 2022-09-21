//
//  File.swift
//  NewsApp-SwiftUI
//
//  Created by User on 21.09.2022.
//

import SwiftUI

struct RoundedCornersShape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
    
    let corners: UIRectCorner
    let radius: CGFloat
}
