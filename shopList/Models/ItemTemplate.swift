import Foundation
import SwiftData

@Model
class ItemTemplate {
    var name: String
    var category: String
    var lastPrice: Double?
    var useCount: Int
    var lastUsed: Date?
    
    init(name: String, category: String, lastPrice: Double? = nil) {
        self.name = name
        self.category = category
        self.lastPrice = lastPrice
        self.useCount = 0
    }
}
