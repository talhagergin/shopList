import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var viewModel: ShoppingListViewModel
    @State private var showingNewListSheet = false
    @State private var newListTitle = ""
    
    init(modelContext: ModelContext) {
        self.viewModel = ShoppingListViewModel(modelContext: modelContext)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(String(format: "%.2f TL", viewModel.getTotalSpent()))
                            .font(.title)
                            .foregroundColor(.blue)
                            .bold()
                        
                        ForEach(viewModel.getTotalSpentByPaymentType(), id: \.0) { paymentType, amount in
                            HStack {
                                Text(paymentType.rawValue)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(String(format: "%.2f TL", amount))
                                    .foregroundColor(.secondary)
                            }
                            .font(.caption)
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Total Spent")
                }
                
                Section {
                    ForEach(viewModel.shoppingLists) { list in
                        NavigationLink(destination: ShoppingListDetailView(list: list, viewModel: viewModel)) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(list.title)
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    if list.completedAt != nil {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                                
                                if let completedAt = list.completedAt {
                                    Text(completedAt.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                if let total = list.totalAmount {
                                    HStack {
                                        Text(String(format: "%.2f TL", total))
                                            .foregroundColor(.blue)
                                        
                                        if let paymentType = list.paymentType {
                                            Text("• \(paymentType.rawValue)")
                                        }
                                    }
                                    .font(.caption)
                                }
                                
                                if !list.items.isEmpty {
                                    Text("\(list.items.filter { $0.isCompleted }.count)/\(list.items.count) items completed")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } header: {
                    Text("Shopping Lists")
                }
            }
            .navigationTitle("Shopping Lists")
            .toolbar {
                Button(action: { showingNewListSheet = true }) {
                    Label("New List", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingNewListSheet) {
                NavigationView {
                    Form {
                        Section {
                            TextField("List Title", text: $newListTitle)
                        }
                        
                        Section {
                            Button(action: {
                                if !newListTitle.isEmpty {
                                    viewModel.createNewList(title: newListTitle)
                                    newListTitle = ""
                                    showingNewListSheet = false
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Create List")
                                        .bold()
                                    Spacer()
                                }
                            }
                            .disabled(newListTitle.isEmpty)
                        }
                    }
                    .navigationTitle("New Shopping List")
                    .navigationBarItems(trailing: Button("Cancel") {
                        showingNewListSheet = false
                    })
                }
            }
        }
    }
}
