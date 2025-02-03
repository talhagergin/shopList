import Foundation
import SwiftData
import Combine

class ShoppingListViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Published var shoppingLists: [ShoppingList] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchShoppingLists()
    }
    
    func fetchShoppingLists() {
        let descriptor = FetchDescriptor<ShoppingList>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        shoppingLists = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func createNewList(title: String) {
        let newList = ShoppingList(title: title)
        modelContext.insert(newList)
        try? modelContext.save()
        fetchShoppingLists()
    }
    
    func addItem(to list: ShoppingList, name: String) {
        let newItem = ShoppingItem(name: name)
        list.items.append(newItem)
        try? modelContext.save()
    }
    
    func toggleItem(_ item: ShoppingItem) {
        item.isCompleted.toggle()
        item.updatedAt = Date()
        try? modelContext.save()
    }
    
    func updateItemPrice(_ item: ShoppingItem, price: Double) {
        item.price = price
        item.updatedAt = Date()
        try? modelContext.save()
    }
    
    func completeList(_ list: ShoppingList, totalAmount: Double, paymentType: PaymentType) {
        list.totalAmount = totalAmount
        list.paymentType = paymentType
        list.completedAt = Date()
        try? modelContext.save()
    }
    
    func getTotalSpent() -> Double {
        return shoppingLists
            .compactMap { $0.totalAmount }
            .reduce(0, +)
    }
}
