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
                Section {
                    VStack(spacing: 12) {
                        HStack {
                            Spacer()
                            VStack(spacing: 4) {
                                Text("Toplam Harcama")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Text(String(format: "%.2f TL", viewModel.getTotalSpent()))
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    ForEach(viewModel.shoppingLists) { list in
                        NavigationLink(destination: ShoppingListDetailView(list: list, viewModel: viewModel)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(list.title)
                                        .font(.headline)
                                    
                                    HStack {
                                        Image(systemName: "cart")
                                            .foregroundColor(.secondary)
                                        Text("\(list.items.count) items")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        if list.completedAt != nil {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                   
                                }
                                
                                Spacer()
                                
                                if let total = list.totalAmount {
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text(String(format: "%.2f TL", total))
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.blue)
                                        
                                        if let paymentType = list.paymentType {
                                            Label("", systemImage: paymentType.icon)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("Alışveriş Listesi")
                        Spacer()
                        Text("\(viewModel.shoppingLists.count) lists")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Alışverişlerim")
            .toolbar {
                Button(action: { showingNewListSheet = true }) {
                    Label("Yeni Liste", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingNewListSheet) {
                NavigationView {
                    Form {
                        Section {
                            TextField("Liste Başlığı", text: $newListTitle)
                        } footer: {
                            Text("Listeniz için bir başlık giriniz.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Section {
                            Button(action: createNewList) {
                                HStack {
                                    Spacer()
                                    Text("Listeyi Oluştur")
                                        .bold()
                                    Spacer()
                                }
                            }
                            .disabled(newListTitle.isEmpty)
                        }
                    }
                    .navigationTitle("Yeni Alışveriş Listesi")
                    .navigationBarItems(trailing: Button("İptal") {
                        showingNewListSheet = false
                    })
                }
            }
        }
    }
    
    private func createNewList() {
        if !newListTitle.isEmpty {
            viewModel.createNewList(title: newListTitle)
            newListTitle = ""
            showingNewListSheet = false
        }
    }
}
