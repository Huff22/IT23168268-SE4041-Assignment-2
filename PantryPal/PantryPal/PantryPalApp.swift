//
//  PantryPalApp.swift
//  PantryPal
//
//  Created by Hafsa Faleel on 2026-10-10.
//

import SwiftUI
import SwiftData

@main
struct PantryPalApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PantryItem.self,
            SavedRecipe.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
