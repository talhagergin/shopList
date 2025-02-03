import SwiftUI

struct CompleteShoppingSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    let list: ShoppingList
    let viewModel: ShoppingListViewModel
    
    @State private var totalAmount: Double?
    @State private var selectedPaymentType: PaymentType = .cash
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Toplam Liste")
                        Spacer()
                        Text("\(list.items.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Tamamlanan Listeler")
                        Spacer()
                        Text("\(list.items.filter { $0.isCompleted }.count)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Ödeme Detayları")) {
                    HStack {
                        Text("Toplam Tutar")
                        Spacer()
                        TextField("Tutar", value: $totalAmount, format: .currency(code: "TRY"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("Ödeme Tipi", selection: $selectedPaymentType) {
                        ForEach(PaymentType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                }
                
                Section {
                    Button(action: completeList) {
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
                dismiss()
            })
        }
    }
    
    private func completeList() {
        guard let amount = totalAmount else { return }
        viewModel.completeList(list, totalAmount: amount, paymentType: selectedPaymentType)
        dismiss()
    }
}
