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

    func localiseToCountry() -> String {
        let country = Locale.current.localizedString(forRegionCode: self)
        return country ?? self
    }

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

extension LocalizedStringKey {

    var stringKey: String? {
            Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
        }

    func toString() -> String? {
        let mirror = Mirror(reflecting: self)

        let attributeLabelAndValue = mirror.children.first { arg0 -> Bool in
            let (label, _) = arg0
            if label == "key" {
                return true
            }
            return false
        }

        if let value = attributeLabelAndValue?.value as? String {
            return String.localizedStringWithFormat(
                NSLocalizedString(value, comment: "")
            )
        } else {
            return nil
        }
    }

    func width(usingFont font: UIFont) -> CGFloat? {
        guard let string = self.toString() else {
            return nil
        }
        return string.widthOfString(usingFont: font)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
