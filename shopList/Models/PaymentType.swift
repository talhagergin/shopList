import Foundation

enum PaymentType: String, CaseIterable, Codable {
    case cash = "Cash"
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case digitalWallet = "Digital Wallet"
    
    var icon: String {
        switch self {
        case .cash:
            return "banknote"
        case .creditCard:
            return "creditcard"
        case .debitCard:
            return "card"
        case .digitalWallet:
            return "wallet.pass"
        }
    }
}
