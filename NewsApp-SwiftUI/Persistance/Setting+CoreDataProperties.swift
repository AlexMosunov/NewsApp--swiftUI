//
//  Setting+CoreDataProperties.swift
//  NewsApp-SwiftUI
//
//  Created by User on 23.09.2022.
//
//

import SwiftUI
import CoreData


extension Setting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Setting> {
        return NSFetchRequest<Setting>(entityName: "Setting")
    }

    @NSManaged public var category: String?
    @NSManaged public var language: String
    @NSManaged public var articles: NSSet?

    static func basicFetchRequest() -> FetchRequest<Setting> {
        FetchRequest(
            entity: Setting.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "language == en")
        )
    }
}

// MARK: Generated accessors for articles
extension Setting {

    @objc(addArticlesObject:)
    @NSManaged public func addToArticles(_ value: Article)

    @objc(removeArticlesObject:)
    @NSManaged public func removeFromArticles(_ value: Article)

    @objc(addArticles:)
    @NSManaged public func addToArticles(_ values: NSSet)

    @objc(removeArticles:)
    @NSManaged public func removeFromArticles(_ values: NSSet)

}

extension Setting : Identifiable {

}
