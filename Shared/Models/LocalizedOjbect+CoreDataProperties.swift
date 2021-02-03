//
//  LocalizedOjbect+CoreDataProperties.swift
//  AlbionAssistant (iOS)
//
//  Created by Yaroslav Ark on 02.02.2021.
//
//

import Foundation
import CoreData


extension LocalizedOjbect {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalizedOjbect> {
        return NSFetchRequest<LocalizedOjbect>(entityName: "LocalizedOjbect")
    }

    @NSManaged public var language: String?
    @NSManaged public var localizedString: String?
    @NSManaged public var namedItem: AlbionItem?
    @NSManaged public var describedItem: AlbionItem?

}

extension LocalizedOjbect : Identifiable {

}
