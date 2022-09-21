//
//  Source.swift
//  NewsApp-SwiftUI
//
//  Created by User on 21.09.2022.
//

import CoreData

extension Source {
    static func withNewsSource(_ newsSource: NewsSource, context: NSManagedObjectContext) -> Source? {
        guard let sourceId = newsSource.id else {
            return nil
        }
        let request = NSFetchRequest<Source>(entityName: Source.description())
        request.predicate = NSPredicate(format: "id = %@", sourceId)
        let sources = (try? context.fetch(request)) ?? []
        if let source = sources.first {
            return source
        } else {
            let entity = Source(context: context)
            entity.id = newsSource.id
            entity.name = newsSource.name
            entity.sourceDescription = newsSource.description
            try? context.save()
            return entity
        }
    }
}
