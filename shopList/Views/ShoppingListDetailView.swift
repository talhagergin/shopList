import SwiftUI

struct ShoppingListDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var list: ShoppingList
    @StateObject var viewModel: ShoppingListViewModel
    @State private var newItemName = ""
    @State private var showingCompleteSheet = false
    @State private var totalAmount: Double?
    
    var body: some View {
        List {
            Section(header: Text("Items")) {
                ForEach(list.items) { item in
                    ShoppingItemView(item: item) {
                        viewModel.toggleItem(item)
                    }
                }
            }
            
            Section {
                HStack {
                    TextField("New item", text: $newItemName)
                    Button("Add") {
                        if !newItemName.isEmpty {
                            viewModel.addItem(to: list, name: newItemName)
                            newItemName = ""
                        }
                    }
                }
            }
        }
        .navigationTitle(list.title)
        .toolbar {
            if list.completedAt == nil {
                Button("Complete Shopping") {
                    showingCompleteSheet = true
                }
            }
        }
        .sheet(isPresented: $showingCompleteSheet) {
            NavigationView {
                Form {
                    Section(header: Text("Shopping Total")) {
                        TextField("Total Amount", value: $totalAmount, format: .currency(code: "TRY"))
                            .keyboardType(.decimalPad)
                    }
                    
                    Button("Complete Shopping") {
                        if let amount = totalAmount {
                            viewModel.completeList(list, totalAmount: amount)
                            showingCompleteSheet = false
                        }
                    }
                    .disabled(totalAmount == nil)
                }
                .navigationTitle("Complete Shopping")
                .navigationBarItems(trailing: Button("Cancel") {
                    showingCompleteSheet = false
                })
            }
        }
    }
}
