//
//  Article+CoreDataProperties.swift
//  NewsApp-SwiftUI
//
//  Created by User on 14.09.2022.
//
//

import SwiftUI
import CoreData

extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var source: Source?
    @NSManaged public var sourceId: String?
    @NSManaged public var settings: Set<Setting>
    @NSManaged public var language: String

    static func basicTopNewsFetchRequest(ascendingFilter: Bool) -> FetchRequest<Article> {
        FetchRequest(
            entity: Article.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Article.publishedAt, ascending: ascendingFilter)],
            predicate: NSPredicate(format: "source == nil")
        )
    }

    static func datesRangeTopNewsFetchRequest(
        fromDate: Date, toDate: Date,
        ascendingFilter: Bool
    ) -> FetchRequest<Article> {
        let sortDescriptor = NSSortDescriptor(keyPath: \Article.publishedAt, ascending: ascendingFilter)
        let predicate = NSPredicate(
            format: "publishedAt >= %@ && publishedAt < %@ && source == nil",
            fromDate.toString(), toDate.toString()
        )
        return FetchRequest(
            entity: Article.entity(),
            sortDescriptors: [sortDescriptor],
            predicate: predicate)
    }

    static func datesRangeLanguageTopNewsFetchRequest(
        fromDate: Date, toDate: Date,
        language: String,
        ascendingFilter: Bool
    ) -> FetchRequest<Article> {
        let sortDescriptor = NSSortDescriptor(keyPath: \Article.publishedAt, ascending: ascendingFilter)
        let predicate = NSPredicate(
            format: "publishedAt >= %@ && publishedAt < %@ && language == %@ && source == nil",
            fromDate.toString(), toDate.toString(), language
        )
        return FetchRequest(
            entity: Article.entity(),
            sortDescriptors: [sortDescriptor],
            predicate: predicate)
    }
}

extension Article : Identifiable {

}
