//
//  AlbionAssistantApp.swift
//  Shared
//
//  Created by Yaroslav Ark on 31.01.2021.
//

import SwiftUI

@main
struct AlbionAssistantApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
