//
//  Extensions.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 17.03.2022.
//

import SwiftUI

extension View {
    
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}
