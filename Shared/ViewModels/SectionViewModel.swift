//
//  SectionViewModel.swift
//  AlbionAssistant
//
//  Created by Yaroslav Ark on 02.03.2021.
//

import CoreData

class SectionViewModel: NSObject, NSFetchedResultsControllerDelegate, Identifiable {
    private let item: AlbionItem
    let prices:[MarketItem] = []
    
    private var fetchedResultsController: NSFetchedResultsController<MarketItem>?

    
    init(with item: AlbionItem) {
        self.item = item
        super.init()

        setupFetchedResultsController()
        fetchedResultsController?.delegate = self
    }
 
    func setupFetchedResultsController() {
        let request: NSFetchRequest<MarketItem> = MarketItem.fetchRequest()
        let itemId = item.objectID
        request.predicate = NSPredicate(format: "item == %@", itemId)
        let sort = NSSortDescriptor(key: "city", ascending: true)
        request.sortDescriptors = [sort]
        
        let controller: NSFetchedResultsController<MarketItem> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DatabaseManager.shared.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = controller
    }
}
