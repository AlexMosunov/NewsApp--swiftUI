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

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale.autoupdatingCurrent
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    return formatter
}()
private let relativeFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter
}()

extension Date {
    func toString() -> String {
        dateFormatter.string(from: self)
    }

    func timeAgoDisplay() -> String {
        relativeFormatter.localizedString(for: self, relativeTo: Date())
    }
}

extension String {
    func toDate() -> Date? {
        dateFormatter.date(from: self)
    }

    func localiseToLanguage() -> String {
        let language = Locale.current.localizedString(forLanguageCode: self)
        return language ?? self
    }

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
