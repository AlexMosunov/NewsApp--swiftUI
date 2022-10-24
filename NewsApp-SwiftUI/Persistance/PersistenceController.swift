//
//  PersistenceController.swift
//  NewsApp-SwiftUI
//
//  Created by User on 08.09.2022.
//

import CoreData

struct PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    init() {
        container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { descitpion, error in
            if let error = error {
                fatalError("Persistent Container error: \(error.localizedDescription)")
            }
        }
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]
        context = container.viewContext
        self.context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    func save(completion: @escaping (Error?) -> Void = {_ in}) {
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    func saveAsync() async throws {
        if context.hasChanges {
            try context.save()
        }
    }

    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> Void = {_ in}) {
        context.delete(object)
        save(completion: completion)
    }

    func saveData(articles: [NewsArticle], sourceId: String?) async throws {
        deleteOld()
        articles.forEach { data in
            createArticle(from: data, sourceId: sourceId)
        }

        try await saveAsync()
        print("DEBUG: path - \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
    }

    func createArticle(from data: NewsArticle, sourceId: String?) -> Article? {
        if Article.isDuplicate(data, context: context) {
            return nil
        }
        let entity = Article(context: context)
        entity.author = data.author
        entity.url = data.url
        entity.articleDescription = data.description
        entity.content = data.content
        entity.publishedAt = data.publishedAt
        entity.title = data.title
        entity.urlToImage = data.urlToImage
        if let sourceid = sourceId {
            entity.source = getSourceFor(sourceId: sourceid)
            entity.sourceId = sourceid
        }
        entity.language = Constants.selectedLanguage
        entity.category = Constants.selectedCategory
        entity.country = Constants.selectedCountry

        entity.currentUserId = Constants.userId ?? ""
        return entity
    }

    func toggleArticleFavourite(_ article: Article?) async throws {
        guard let article = article else {
            return
        }
        article.isFavourite.toggle()
        try await saveAsync()
    }

    func getSourceFor(sourceId: String) -> Source? {
        do {
            let sourceRequst = NSFetchRequest<Source>(entityName: Source.description())
            sourceRequst.predicate = NSPredicate(format: "id = %@", sourceId)
            let source: [Source] = try context.fetch(sourceRequst)
            return source.first
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    func saveSources(sources: [NewsSource]) async throws {
        sources.forEach { data in
            _ = Source.withNewsSource(data, context: context)
        }
        try await saveAsync()
    }

    private func deleteArticleDuplicates(title: String, publishedAt: String) {
        do {
            let fetchRequest = NSFetchRequest<Article>.init(entityName: Article.description())
            fetchRequest.predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    NSPredicate(format: "title == %@", title),
                    NSPredicate(format: "publishedAt == %@", publishedAt)
                ]
            )
            fetchRequest.fetchBatchSize = 20
            let duplicates: [Article] = try context.fetch(fetchRequest)
            for item in duplicates {
                delete(item)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func getRandomArticle() -> Article? {
        let request = NSFetchRequest<Article>(entityName: Article.description())
        let articles = (try? context.fetch(request)) ?? []
        return articles.first
    }

    private func deleteOld() {
        do {
            let fetchRequest = NSFetchRequest<Article>.init(entityName: Article.description())
            let articles: [Article] = try context.fetch(fetchRequest)
            for item in articles {
                if numberOfDaysSinceNow(dateString: item.publishedAt ?? "") > Constants.maxDaysOld
                   && item.isFavourite == false {
                    delete(item)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func numberOfDaysSinceNow(dateString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateFormatter.date(from: dateString) ?? Date()
        let calendar = Calendar.current
        let lhs = calendar.startOfDay(for: date).timeIntervalSince1970
        let rhs = calendar.startOfDay(for: Date()).timeIntervalSince1970
        return Int(round((lhs - rhs) / 60 / 60 / 24))
    }
}
