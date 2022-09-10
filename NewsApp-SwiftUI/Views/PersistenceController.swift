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
        context = container.viewContext
    }

    func save(completion: @escaping (Error?) -> () = {_ in}) {
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

    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
        context.delete(object)
        save(completion: completion)
    }

    func saveData(articles: [NewsArticle]) async throws {
        articles.forEach { data in
            deleteDuplicates(title: data.title, publishedAt: data.publishedAt)
            let entity = Article(context: context)
            entity.author = data.author
            entity.url = data.url
            entity.articleDescription = data.description
            entity.content = data.content
            entity.publishedAt = data.publishedAt
            entity.title = data.title
            entity.urlToImage = data.urlToImage
        }

        //TODO: change, handel error to UI
        try await saveAsync()
    }

    private func deleteDuplicates(title: String, publishedAt: String) {
        do {
            let days = numberOfDaysSinceNow(dateString: publishedAt)
            let fetchRequest = NSFetchRequest<Article>.init(entityName: Article.description())
            fetchRequest.predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    NSPredicate(format: "title == %@", title),
                    NSPredicate(format: "publishedAt == %@", publishedAt)
                ]
            )
            fetchRequest.fetchBatchSize = 10
            let duplicates: [Article] = try context.fetch(fetchRequest)
            for item in duplicates {
                delete(item)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func numberOfDaysSinceNow(dateString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'Z"
        let date = dateFormatter.date(from: dateString) ?? Date()
        let calendar = Calendar(identifier: .gregorian)
        let lhs = calendar.startOfDay(for: date).timeIntervalSince1970
        let rhs = calendar.startOfDay(for: Date()).timeIntervalSince1970
        return Int(round((lhs - rhs) / 60 / 60 / 24))
    }
}
