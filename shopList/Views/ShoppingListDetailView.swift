import SwiftUI

struct ShoppingListDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var list: ShoppingList
    @StateObject var viewModel: ShoppingListViewModel
    @State private var newItemName = ""
    @State private var showingCompleteSheet = false
    
    var body: some View {
        List {
            if list.completedAt != nil {
                Section {
                    VStack(spacing: 12) {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title)
                            Text("Tamamlandı")
                                .font(.headline)
                            Spacer()
                        }
                        
                        if let total = list.totalAmount {
                            HStack {
                                Spacer()
                                VStack(spacing: 4) {
                                    Text("Toplam Tutar")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(String(format: "%.2f TL", total))
                                        .font(.title2)
                                        .bold()
                                }
                                Spacer()
                            }
                        }
                        
                        if let paymentType = list.paymentType {
                            HStack {
                                Spacer()
                                Label(paymentType.rawValue, systemImage: paymentType.icon)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            Section(header: Text("Ürün")) {
                ForEach(list.items) { item in
                    ShoppingItemView(item: item) {
                        viewModel.toggleItem(item)
                    }
                }
            }
            
            if list.completedAt == nil {
                Section {
                    HStack {
                        TextField("Yeni Ürün", text: $newItemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            if !newItemName.isEmpty {
                                viewModel.addItem(to: list, name: newItemName)
                                newItemName = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                        .disabled(newItemName.isEmpty)
                    }
                }
            }
        }
        .navigationTitle(list.title)
        .toolbar {
            if list.completedAt == nil {
                Button(action: { showingCompleteSheet = true }) {
                    Label("Tamamla", systemImage: "checkmark.circle")
                }
            }
        }
        .sheet(isPresented: $showingCompleteSheet) {
            CompleteShoppingSheet(isPresented: $showingCompleteSheet,
                                list: list,
                                viewModel: viewModel)
        }
    }
}
