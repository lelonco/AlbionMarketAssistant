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
            DatabaseManager.shared.persistantContainer.performBackgroundTask { (bgContext) in
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context] = context
                    let parsed = try decoder.decode([AlbionNetworkModel].self, from: data)
                    _ = parsed.map { (networkModel) -> AlbionItem in
                        return AlbionItem(networkModel: networkModel, context: bgContext)
                    }
                    DatabaseManager.shared.saveContext(bgContext)
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
