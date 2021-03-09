//
//  SectionViewModel.swift
//  AlbionAssistant
//
//  Created by Yaroslav Ark on 02.03.2021.
//

import CoreData
import Combine
class SectionViewModel: NSObject, NSFetchedResultsControllerDelegate, Identifiable, ObservableObject {
    private let item: AlbionItem
    @Published var imageData: Data? = nil

    let prices:[MarketItem] = []
    
    private var fetchedResultsController: NSFetchedResultsController<MarketItem>?

    private let imageManager = ImageManager.shared
    private var disposables = Set<AnyCancellable>()
    init(with item: AlbionItem) {
        self.item = item
        super.init()

        setupFetchedResultsController()
        fetchedResultsController?.delegate = self
    }
 
    func prepareImage() {
        imageManager.imageData(for: item)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { (error) in
                print(error)
            } receiveValue: { [weak self] (image) in
                self?.imageData = image.pngData()
                self?.disposables.forEach({ $0.cancel() })
            }
            .store(in: &disposables)
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
