//
//  Settings+CoreDataProperties.swift
//  NewsApp-SwiftUI
//
//  Created by User on 23.09.2022.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var selectedSetting: Setting?
    @NSManaged public var settings: Set<Setting>

}

// MARK: Generated accessors for settings
extension Settings {

    @objc(addSettingsObject:)
    @NSManaged public func addToSettings(_ value: Setting)

    @objc(removeSettingsObject:)
    @NSManaged public func removeFromSettings(_ value: Setting)

    @objc(addSettings:)
    @NSManaged public func addToSettings(_ values: NSSet)

    @objc(removeSettings:)
    @NSManaged public func removeFromSettings(_ values: NSSet)

}

extension Settings : Identifiable {

}
