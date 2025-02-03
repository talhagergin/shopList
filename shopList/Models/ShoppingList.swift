import Foundation
import SwiftData

enum PaymentType: String, Codable {
    case card = "Card"
    case cash = "Cash"
    case ticket = "Ticket"
}

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
