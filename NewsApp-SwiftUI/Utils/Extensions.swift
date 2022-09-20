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

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
