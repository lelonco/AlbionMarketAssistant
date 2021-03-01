//
//  AlbionItem+CoreDataClass.swift
//  AlbionAssistant
//
//  Created by Yaroslav Ark on 31.01.2021.
//
//

import Foundation
import CoreData

@objc(AlbionItem)
public class AlbionItem: NSManagedObject {
    
    convenience init(networkModel: AlbionNetworkModel, context:NSManagedObjectContext = DatabaseManager.shared.managedContext) {
        self.init(context: context)
        self.index = networkModel.index
        self.localizationDescriptionVariable = networkModel.localizationDescriptionVariable
        self.localizationNameVariable = networkModel.localizationNameVariable
        self.uniqueName = networkModel.uniqueName
        self.localizedNames = NSSet(array: networkModel.localizedNames?.map({ (key: String, value: String) -> LocalizedOjbect in
            let localizedItem = LocalizedOjbect(context: context)
            localizedItem.language = key
            localizedItem.localizedString = value
            return localizedItem
        }) ?? [])
        
        self.localizedDescriptions = NSSet(array: networkModel.localizedNames?.map({ (key: String, value: String) -> LocalizedOjbect in
            let localizedItem = LocalizedOjbect(context: context)
            localizedItem.language = key
            localizedItem.localizedString = value
            return localizedItem
        }) ?? [])
        
    }
}
