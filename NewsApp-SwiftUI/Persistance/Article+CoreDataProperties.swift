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
    @NSManaged public var category: String
    @NSManaged public var country: String

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
            format: "publishedAt >= %@ && publishedAt < %@ && language == %@ && category == %@ && country == %@ && source == nil",
            settingFilter.fromDate.toString(),
            settingFilter.toDate.toString(),
            settingFilter.language.rawValue,
            settingFilter.selection.rawValue,
            settingFilter.country.rawValue
        )
        return FetchRequest(
            entity: Article.entity(),
            sortDescriptors: [sortDescriptor],
            predicate: predicate)
    }
}

extension Article : Identifiable {
//    static func withArticle(_ newsArticle: NewsArticle, context: NSManagedObjectContext) {
//        let request = NSFetchRequest<Article>(entityName: Article.description())
//        request.predicate = NSPredicate(
//            format: "title = %@ && publishedAt == %@",
//            newsArticle.title, newsArticle.publishedAt
//        )
//        let articles = (try? context.fetch(request)) ?? []
//        if let article = articles.first {
//            return
//        } else {
//            let entity = Article(context: context)
//            entity.author = newsArticle.author
//            entity.url = newsArticle.url
//            entity.articleDescription = newsArticle.description
//            entity.content = newsArticle.content
//            entity.publishedAt = newsArticle.publishedAt
//            entity.title = newsArticle.title
//            entity.urlToImage = newsArticle.urlToImage
//            if let sourceid = sourceId {
//                entity.source = getSourceFor(sourceId: sourceid)
//                entity.sourceId = sourceid
//            }
//            if let setting = getSetting() {
//                entity.settings = [setting]
//                entity.language = setting.language
//                entity.category = setting.category ?? ""
//            }
//        }
//    }
}
