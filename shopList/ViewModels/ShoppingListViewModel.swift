import Foundation
import SwiftData
import Combine

class ShoppingListViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Published var shoppingLists: [ShoppingList] = []
    @Published var itemTemplates: [ItemTemplate] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchShoppingLists()
        fetchItemTemplates()
    }
    
    func fetchShoppingLists() {
        let descriptor = FetchDescriptor<ShoppingList>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        shoppingLists = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchItemTemplates() {
        let descriptor = FetchDescriptor<ItemTemplate>(sortBy: [SortDescriptor(\.useCount, order: .reverse)])
        itemTemplates = (try? modelContext.fetch(descriptor)) ?? []
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
    
    func addItemFromTemplate(to list: ShoppingList, template: ItemTemplate) {
        let newItem = ShoppingItem(name: template.name)
        newItem.price = template.lastPrice
        list.items.append(newItem)
        
        // Update template statistics
        template.useCount += 1
        template.lastUsed = Date()
        
        try? modelContext.save()
    }
    
    func createTemplate(name: String, category: String, lastPrice: Double?) {
        let template = ItemTemplate(name: name, category: category, lastPrice: lastPrice)
        modelContext.insert(template)
        try? modelContext.save()
        fetchItemTemplates()
    }
    
    func updateTemplate(_ template: ItemTemplate, withItem item: ShoppingItem) {
        template.lastPrice = item.price
        template.lastUsed = Date()
        template.useCount += 1
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
        
        // Update template if exists
        if let template = itemTemplates.first(where: { $0.name == item.name }) {
            updateTemplate(template, withItem: item)
        }
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
    
    func getTotalSpentByPaymentType() -> [(PaymentType, Double)] {
        var totals: [PaymentType: Double] = [:]
        for list in shoppingLists {
            if let amount = list.totalAmount, let paymentType = list.paymentType {
                totals[paymentType, default: 0] += amount
            }
        }
        return totals.map { ($0.key, $0.value) }.sorted { $0.1 > $1.1 }
    }
    
    func getFrequentlyUsedTemplates(limit: Int = 5) -> [ItemTemplate] {
        return Array(itemTemplates.prefix(limit))
    }
    
    func getTemplatesByCategory() -> [String: [ItemTemplate]] {
        Dictionary(grouping: itemTemplates) { $0.category }
    }
}
