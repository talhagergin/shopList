import SwiftUI

struct ShoppingListDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var list: ShoppingList
    @ObservedObject var viewModel: ShoppingListViewModel
    @State private var newItemName = ""
    @State private var showingCompleteSheet = false
    @State private var showingTemplateSheet = false
    @State private var totalAmount: Double?
    @State private var selectedPaymentType: PaymentType = .card
    
    var body: some View {
        List {
            if !list.items.isEmpty {
                Section {
                    ForEach(list.items) { item in
                        ShoppingItemView(item: item) {
                            viewModel.toggleItem(item)
                        }
                    }
                } header: {
                    HStack {
                        Text("Items")
                        Spacer()
                        Text("\(list.items.filter { $0.isCompleted }.count)/\(list.items.count)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section {
                HStack {
                    TextField("Add new item", text: $newItemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if !newItemName.isEmpty {
                            viewModel.addItem(to: list, name: newItemName)
                            newItemName = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                    }
                    .disabled(newItemName.isEmpty)
                    
                    Button(action: { showingTemplateSheet = true }) {
                        Image(systemName: "list.bullet.rectangle.portrait")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                    }
                }
            }
        }
        .navigationTitle(list.title)
        .toolbar {
            if list.completedAt == nil {
                Button(action: { showingCompleteSheet = true }) {
                    Label("Complete Shopping", systemImage: "cart.badge.checkmark")
                }
            }
        }
        .sheet(isPresented: $showingCompleteSheet) {
            NavigationView {
                Form {
                    Section(header: Text("Shopping Details")) {
                        TextField("Total Amount", value: $totalAmount, format: .currency(code: "TRY"))
                            .keyboardType(.decimalPad)
                        
                        Picker("Payment Method", selection: $selectedPaymentType) {
                            ForEach([PaymentType.card, .cash, .ticket], id: \.self) { type in
                                Text(type.rawValue)
                                    .tag(type)
                            }
                        }
                    }
                    
                    Section {
                        Button(action: {
                            if let amount = totalAmount {
                                viewModel.completeList(list, totalAmount: amount, paymentType: selectedPaymentType)
                                showingCompleteSheet = false
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("Complete Shopping")
                                    .bold()
                                Spacer()
                            }
                        }
                        .disabled(totalAmount == nil)
                    }
                }
                .navigationTitle("Complete Shopping")
                .navigationBarItems(trailing: Button("Cancel") {
                    showingCompleteSheet = false
                })
            }
        }
        .sheet(isPresented: $showingTemplateSheet) {
            ItemTemplateView(viewModel: viewModel) { template in
                viewModel.addItemFromTemplate(to: list, template: template)
            }
        }
    }
}
