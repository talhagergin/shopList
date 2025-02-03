import SwiftUI

struct ShoppingItemView: View {
    @Bindable var item: ShoppingItem
    var onToggle: () -> Void
    @State private var showingPriceInput = false
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .gray)
            }
            
            Text(item.name)
                .strikethrough(item.isCompleted)
            
            Spacer()
            
            if let price = item.price {
                Text(String(format: "%.2f TL", price))
                    .foregroundColor(.blue)
            }
            
            Button(action: { showingPriceInput = true }) {
                Image(systemName: "pencil.circle")
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .alert("Fiyat Gir", isPresented: $showingPriceInput) {
            TextField("Fiyat", value: $item.price, format: .number)
                .keyboardType(.decimalPad)
            Button("Tamam", action: {})
            Button("İptal", role: .cancel, action: {})
        } message: {
            Text("Fiyatını girin \(item.name)")
        }
    }
}
