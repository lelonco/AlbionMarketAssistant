//
//  AlbionAssistantApp.swift
//  Shared
//
//  Created by Yaroslav Ark on 31.01.2021.
//

import SwiftUI

@main
struct AlbionAssistantApp: App {
    let context = DatabaseManager.shared.managedContext
    var body: some Scene {

        WindowGroup {
            ContentView().onAppear(perform: {
                self.createInitialDataIfNeeded()
            })
            .environment(\.managedObjectContext,context )

        }
    }
    
    func createInitialDataIfNeeded() {
        guard UserDefaults.isFirstLaunch() else { return }
        if let path = Bundle.main.path(forResource: "items", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.context] = context
                let parsed = try decoder.decode([AlbionNetworkModel].self, from: data)
                _ = parsed.map { (networkModel) -> AlbionItem in
                    let item = AlbionItem(context: self.context)
                    
                    item.index = networkModel.index
                    item.localizationDescriptionVariable = networkModel.localizationDescriptionVariable
                    item.localizationNameVariable = networkModel.localizationNameVariable
                    item.uniqueName = networkModel.uniqueName
                    item.localizedNames = NSSet(array: networkModel.localizedNames?.map({ (key: String, value: String) -> LocalizedOjbect in
                        let localizedItem = LocalizedOjbect(context: self.context)
                        localizedItem.language = key
                        localizedItem.localizedString = value
                        return localizedItem
                    }) ?? [])
                    
                    item.localizedDescriptions = NSSet(array: networkModel.localizedNames?.map({ (key: String, value: String) -> LocalizedOjbect in
                        let localizedItem = LocalizedOjbect(context: self.context)
                        localizedItem.language = key
                        localizedItem.localizedString = value
                        return localizedItem
                    }) ?? [])

                    return item
                }
                DatabaseManager.shared.saveContext()
            } catch {
                fatalError(error.localizedDescription)
            }

        }
    }
}
