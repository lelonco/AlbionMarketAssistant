//
//  MarketItem+CoreDataProperties.swift
//  AlbionAssistant
//
//  Created by Yaroslav Ark on 02.03.2021.
//
//

import Foundation
import CoreData


extension MarketItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MarketItem> {
        return NSFetchRequest<MarketItem>(entityName: "MarketItem")
    }

    @NSManaged public var city: String?
    @NSManaged public var quality: Int16
    @NSManaged public var sellPriceMin: Int32
    @NSManaged public var sellPriceMax: Int32
    @NSManaged public var buyPriceMin: Int32
    @NSManaged public var buyPriceMax: Int32
    @NSManaged public var buyPriceMaxDate: Date?
    @NSManaged public var buyPriceMinDate: Date?
    @NSManaged public var sellPriceMaxDate: Date?
    @NSManaged public var sellPriceMinDate: Date?
    @NSManaged public var item: AlbionItem?

}

extension MarketItem : Identifiable {

}
