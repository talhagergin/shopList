import SwiftUI

struct ItemTemplateView: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingNewTemplateSheet = false
    @State private var newTemplateName = ""
    @State private var newTemplateCategory = ""
    @State private var newTemplatePrice: Double?
    
    let onSelectTemplate: (ItemTemplate) -> Void
    
    var body: some View {
        NavigationView {
            List {
                // Frequently used templates
                Section(header: Text("Frequently Used")) {
                    ForEach(viewModel.getFrequentlyUsedTemplates(), id: \.self) { template in
                        templateRow(template)
                    }
                }
                
                // Templates by category
                ForEach(Array(viewModel.getTemplatesByCategory().keys.sorted()), id: \.self) { category in
                    Section(header: Text(category)) {
                        ForEach(viewModel.getTemplatesByCategory()[category] ?? [], id: \.self) { template in
                            templateRow(template)
                        }
                    }
                }
            }
            .navigationTitle("Item Templates")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewTemplateSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewTemplateSheet) {
                NavigationView {
                    Form {
                        Section {
                            TextField("Item Name", text: $newTemplateName)
                            TextField("Category", text: $newTemplateCategory)
                            TextField("Last Price", value: $newTemplatePrice, format: .currency(code: "TRY"))
                                .keyboardType(.decimalPad)
                        }
                        
                        Section {
                            Button("Create Template") {
                                if !newTemplateName.isEmpty && !newTemplateCategory.isEmpty {
                                    viewModel.createTemplate(
                                        name: newTemplateName,
                                        category: newTemplateCategory,
                                        lastPrice: newTemplatePrice
                                    )
                                    newTemplateName = ""
                                    newTemplateCategory = ""
                                    newTemplatePrice = nil
                                    showingNewTemplateSheet = false
                                }
                            }
                            .disabled(newTemplateName.isEmpty || newTemplateCategory.isEmpty)
                        }
                    }
                    .navigationTitle("New Template")
                    .navigationBarItems(trailing: Button("Cancel") {
                        showingNewTemplateSheet = false
                    })
                }
            }
        }
    }
    
    private func templateRow(_ template: ItemTemplate) -> some View {
        Button(action: {
            onSelectTemplate(template)
            dismiss()
        }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(template.name)
                    .foregroundColor(.primary)
                
                HStack {
                    if let lastPrice = template.lastPrice {
                        Text(String(format: "%.2f TL", lastPrice))
                            .foregroundColor(.blue)
                    }
                    
                    if let lastUsed = template.lastUsed {
                        Text("• Last used: \(lastUsed.formatted(.relative(presentation: .named)))")
                    }
                    
                    Text("• Used \(template.useCount) times")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
        }
    }
}
