import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var viewModel: ShoppingListViewModel
    @State private var showingNewListSheet = false
    @State private var newListTitle = ""
    
    init(modelContext: ModelContext) {
        _viewModel = ObservedObject(wrappedValue: ShoppingListViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Total Spent")) {
                    Text(String(format: "%.2f TL", viewModel.getTotalSpent()))
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
                Section(header: Text("Shopping Lists")) {
                    ForEach(viewModel.shoppingLists) { list in
                        NavigationLink(destination: ShoppingListDetailView(list: list, viewModel: viewModel)) {
                            VStack(alignment: .leading) {
                                Text(list.title)
                                    .font(.headline)
                                if let completedAt = list.completedAt {
                                    Text("Completed: \(completedAt.formatted())")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                if let total = list.totalAmount {
                                    Text(String(format: "Total: %.2f TL", total))
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Shopping Lists")
            .toolbar {
                Button("New List") {
                    showingNewListSheet = true
                }
            }
            .sheet(isPresented: $showingNewListSheet) {
                NavigationView {
                    Form {
                        TextField("List Title", text: $newListTitle)
                        
                        Button("Create") {
                            if !newListTitle.isEmpty {
                                viewModel.createNewList(title: newListTitle)
                                newListTitle = ""
                                showingNewListSheet = false
                            }
                        }
                        .disabled(newListTitle.isEmpty)
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
