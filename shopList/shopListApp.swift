//
//  ShopListApp.swift
//  ShopList
//
//  Created by Talha Gergin on 3.02.2025.
//

import SwiftUI
import SwiftData

@main
struct ShopListApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: ShoppingList.self, ShoppingItem.self)
        } catch {
            fatalError("Failed to initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
}
