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

    init() {
        container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { descitpion, error in
            if let error = error {
                fatalError("Persistent Container error: \(error.localizedDescription)")
            }
        }
    }

    func save(completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
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
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }

    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        context.delete(object)
        save(completion: completion)
    }

    func saveData(articles: [NewsArticle]) async throws {
        guard let existingArticles: [Article] = try container.viewContext.fetch(
            NSFetchRequest<Article>.init(entityName: Article.description())
        ) as? [Article] else {
            return
        }
        articles.forEach { data in
            existingArticles.forEach { art in
                if art.title == data.title && art.publishedAt == data.publishedAt {
                    delete(art)
                }
            }
            let entity = Article(context: container.viewContext)
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
}
