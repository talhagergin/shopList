import Foundation

enum PaymentType: String, CaseIterable, Codable {
    case cash = "Nakit"
    case creditCard = "Kredi Kartı"
    case ticket = "Yemek Kartı"
    
    var icon: String {
        switch self {
        case .cash:
            return "banknote"
        case .creditCard:
            return "creditcard"
        case .ticket:
            return "fork.knife.circle.fill"
        }
    }
}
