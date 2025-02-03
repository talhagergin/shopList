import Foundation
import SwiftData

@Model
class ShoppingItem {
    var name: String
    var isCompleted: Bool
    var price: Double?
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, isCompleted: Bool = false, price: Double? = nil) {
        self.name = name
        self.isCompleted = isCompleted
        self.price = price
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
