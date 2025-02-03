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
                    .imageScale(.large)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .strikethrough(item.isCompleted)
                    .foregroundColor(item.isCompleted ? .gray : .primary)
                
                if let price = item.price {
                    Text(String(format: "%.2f TL", price))
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            Button(action: { showingPriceInput = true }) {
                Label("Set Price", systemImage: "pencil.circle")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.blue)
                    .imageScale(.large)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .alert("Set Price", isPresented: $showingPriceInput) {
            TextField("Price", value: $item.price, format: .number)
                .keyboardType(.decimalPad)
            Button("Save", action: {})
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text("Enter the price for \(item.name)")
        }
    }
}
