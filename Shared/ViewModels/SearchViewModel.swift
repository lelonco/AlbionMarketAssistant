//
//  SearchViewModel.swift
//  AlbionAssistant
//
//  Created by Yaroslav Ark on 31.01.2021.
//

import Foundation
import CoreData
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet {
            print(searchText)
        }
    }
    @Published var data: Data? = nil
    @Published var fecthedResults: [AlbionItem]! = []
    private var disposables = Set<AnyCancellable>()
    private var fetchedResultsController: NSFetchedResultsController<AlbionItem>? = nil
    init() {
        let request = self.createFetchRequest()
        
        try! DatabaseManager.shared.managedContext.execute(request)
        (request)
        
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { (_) in
                let request = self.createFetchRequest()
                try! DatabaseManager.shared.managedContext.execute(request)
            }
            .store(in: &disposables)
        $data
            .sink { (data) in
                guard let data = data else { return }
                var path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                path.appendPathComponent("image.jpg")//               "/Users/yaroslav/Library/Developer/CoreSimulator/Devices/1B9BE451-4057-4348-BE09-7B5DFBA2CBC7/data/Containers/Bundle/Application/2A4FD907-A08A-49A5-94EB-572267FB2745/image.jpg"
                try! data.write(to: path)
            }
            .store(in: &disposables)
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
            self.fecthedResults = items.finalResult ?? []
        })
        return asyncRequest
    }
    
}
