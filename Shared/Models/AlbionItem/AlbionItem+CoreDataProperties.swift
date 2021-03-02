//
//  AlbionItem+CoreDataProperties.swift
//  AlbionAssistant (iOS)
//
//  Created by Yaroslav Ark on 02.02.2021.
//
//

import Foundation
import CoreData


extension AlbionItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbionItem> {
        return NSFetchRequest<AlbionItem>(entityName: "AlbionItem")
    }

    @NSManaged public var index: String?
    @NSManaged public var localizationDescriptionVariable: String?
    @NSManaged public var localizationNameVariable: String?
    @NSManaged public var uniqueName: String?
    @NSManaged public var localizedNames: NSSet?
    @NSManaged public var localizedDescriptions: NSSet?

}

// MARK: Generated accessors for localizedNames
extension AlbionItem {

    @objc(addLocalizedNamesObject:)
    @NSManaged public func addToLocalizedNames(_ value: LocalizedOjbect)

    @objc(removeLocalizedNamesObject:)
    @NSManaged public func removeFromLocalizedNames(_ value: LocalizedOjbect)

    @objc(addLocalizedNames:)
    @NSManaged public func addToLocalizedNames(_ values: NSSet)

    @objc(removeLocalizedNames:)
    @NSManaged public func removeFromLocalizedNames(_ values: NSSet)

}

// MARK: Generated accessors for localizedDescriptions
extension AlbionItem {

    @objc(addLocalizedDescriptionsObject:)
    @NSManaged public func addToLocalizedDescriptions(_ value: LocalizedOjbect)

    @objc(removeLocalizedDescriptionsObject:)
    @NSManaged public func removeFromLocalizedDescriptions(_ value: LocalizedOjbect)

    @objc(addLocalizedDescriptions:)
    @NSManaged public func addToLocalizedDescriptions(_ values: NSSet)

    @objc(removeLocalizedDescriptions:)
    @NSManaged public func removeFromLocalizedDescriptions(_ values: NSSet)

}

extension AlbionItem : Identifiable {

}
