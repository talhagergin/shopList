import Foundation
import SwiftData

@Model
class ShoppingList {
    var title: String
    var items: [ShoppingItem]
    var totalAmount: Double?
    var paymentType: PaymentType?
    var createdAt: Date
    var completedAt: Date?
    
    init(title: String, items: [ShoppingItem] = []) {
        self.title = title
        self.items = items
        self.createdAt = Date()
    }
}
