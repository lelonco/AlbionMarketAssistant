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
    
    @Published var fecthedResults: [AlbionItem]! = []
    private var disposables = Set<AnyCancellable>()

    init() {
        let request = self.createFetchRequest()
        self.fecthedResults = try! DatabaseManager.shared.managedContext.fetch(request)
        
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { (_) in
                let request = self.createFetchRequest()
                self.fecthedResults = try! DatabaseManager.shared.managedContext.fetch(request)
            }
            .store(in: &disposables)
    }
    
    func createFetchRequest() -> NSFetchRequest<AlbionItem> {
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
        return request
    }
    
}
