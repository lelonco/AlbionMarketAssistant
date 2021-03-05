//
//  SearchViewModel.swift
//  AlbionAssistant
//
//  Created by Yaroslav Ark on 31.01.2021.
//

import Foundation
import CoreData
import Combine

class SearchViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    @Published var searchText: String = "" {
        didSet {
            print(searchText)
        }
    }
    @Published var data: Data? = nil
    @Published var fecthedResults: [SectionViewModel]! = []
    private var disposables = Set<AnyCancellable>()
    private var fetchedResultsController: NSFetchedResultsController<AlbionItem> = {
        let request: NSFetchRequest<AlbionItem> = AlbionItem.fetchRequest()
        let sort = NSSortDescriptor(key: "uniqueName", ascending: true)
        request.sortDescriptors = [sort]
        
        let controller: NSFetchedResultsController<AlbionItem> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DatabaseManager.shared.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()
    
    override init() {
        super.init()
        fetchedResultsController.delegate = self
        let request = self.createFetchRequest()
        try! fetchedResultsController.performFetch()
        try! DatabaseManager.shared.managedContext.execute(request)
        
//        let apireq = AlbionApi.getImageFor(item: "T4_BAG", quality: 4, enchantment: 3)
//        NetworkManager.shared.makeRequest(apireq).sink { (error) in
//            print(error)
//        } receiveValue: { (data: Data, response: URLResponse) in
//            print(response)
//            self.data = data
//        }.store(in: &disposables)

        //TODO: - create async fetchreq
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { (_) in
                let request = self.createFetchRequest()
                try! DatabaseManager.shared.managedContext.execute(request)
            }
            .store(in: &disposables)
        
//        $data
//            .sink { (data) in
//                guard let data = data else { return }
//                var path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                path.appendPathComponent("image.jpg")
//                try! data.write(to: path)
//            }
//            .store(in: &disposables)
    }
    
    func buttonTapped() {
        let req = URLRequest(url: URL(string: "https://render.albiononline.com/v1/item/T8_2H_BOW@3")!)
        URLSession.shared.dataTaskPublisher(for: req)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (complition) in
                switch complition {
                case .finished:
                    break
                case let .failure(error):
                    print(error)
                }
            }, receiveValue: { [self] (data: Data, response: URLResponse) in
                self.data = data
                print(response)
            })
            .store(in: &disposables)
    }

    func createFetchRequest() -> NSAsynchronousFetchRequest<AlbionItem> {
        let request: NSFetchRequest<AlbionItem> = AlbionItem.fetchRequest()
        if !searchText.isEmpty {
            let predicate = NSPredicate(
                format: "SUBQUERY(" +
                    "localizedNames, " +
                    "$name, " +
                    "$name.localizedString CONTAINS[cd] \"\(searchText)\"" +
                    ").@count > 0"
            )
            request.predicate = predicate
            let sort = NSSortDescriptor(key: "uniqueName", ascending: true)
            request.sortDescriptors = [sort]
        }
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request, completionBlock: { (items) in
            self.fecthedResults = items.finalResult?.map({SectionViewModel(with: $0) }) ?? []
        })
        return asyncRequest
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith diff: CollectionDifference<NSManagedObjectID>) {
        self.fecthedResults = self.fetchedResultsController.fetchedObjects?.map({ SectionViewModel(with: $0) })
    }

}
