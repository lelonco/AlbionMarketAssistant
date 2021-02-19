//
//  CoreDataManager.swift
//  AlbionAssistant
//
//  Created by Yaroslav Ark on 31.01.2021.
//

import CoreData

protocol DatabaseManagerProtocol {
    var persistantContainer: PersistentContainer { get }
    var managedContext: NSManagedObjectContext { get }
    func saveContext(_ managedContext: NSManagedObjectContext?)
}

extension DatabaseManagerProtocol {
    func saveContext(_ managedContext: NSManagedObjectContext? = nil) {
        persistantContainer.saveContext(backgroundContext: managedContext)
    }
}

class DatabaseManager: DatabaseManagerProtocol {
    static let shared = DatabaseManager()

    lazy var persistantContainer: PersistentContainer = {
        let persistantContainer = PersistentContainer(name: "AlbionAssistant")

        persistantContainer.loadPersistentStores { _, error in
            persistantContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                fatalError("Unresolved error: \(error.localizedDescription)")
            }
        }
        return persistantContainer
    }()

    lazy var managedContext: NSManagedObjectContext = {
        persistantContainer.viewContext
    }()

    init() {
        
    }
}