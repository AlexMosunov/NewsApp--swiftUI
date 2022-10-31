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
    @NSManaged public var language: String
    @NSManaged public var category: String
    @NSManaged public var country: String
    @NSManaged public var isFavourite: Bool
    @NSManaged public var currentUserId: String
    @NSManaged public var searchQuery: String?
    @NSManaged public var searchFilter: String?

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
        settingFilter: SettingsFilter,
        ascendingFilter: Bool
    ) -> FetchRequest<Article> {
        let sortDescriptor = NSSortDescriptor(keyPath: \Article.publishedAt, ascending: ascendingFilter)
        let predicate = NSPredicate(
            format: "publishedAt >= %@ && publishedAt < %@ && language == %@ && category == %@ && country == %@ && currentUserId == %@ && source == nil && searchQuery == nil",
            settingFilter.fromDate.toString(),
            settingFilter.toDate.toString(),
            settingFilter.language.rawValue,
            settingFilter.selection.rawValue,
            settingFilter.country.rawValue,
            Constants.userId ?? ""
        )
        return FetchRequest(
            entity: Article.entity(),
            sortDescriptors: [sortDescriptor],
            predicate: predicate)
    }

    static func favouritesWithCategoriesRequest(
        category: Categories
    ) -> FetchRequest<Article> {
        let sortDescriptor = NSSortDescriptor(keyPath: \Article.publishedAt, ascending: false)
        let predicate = NSPredicate(
            format: "isFavourite == true && category == %@ && currentUserId == %@",
            category.rawValue,
            Constants.userId ?? ""
        )
        return FetchRequest(
            entity: Article.entity(),
            sortDescriptors: [sortDescriptor],
            predicate: predicate
        )
    }
}

extension Article : Identifiable {
    static func isDuplicate(_ newsArticle: NewsArticle, context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest<Article>(entityName: Article.description())
        request.predicate = NSPredicate(
            format: "title = %@ && publishedAt == %@ && currentUserId == %@",
            newsArticle.title, newsArticle.publishedAt, Constants.userId ?? ""
        )
        let articles = (try? context.fetch(request)) ?? []
        if articles.first != nil {
            return true
        } else {
            return false
        }
    }
}
