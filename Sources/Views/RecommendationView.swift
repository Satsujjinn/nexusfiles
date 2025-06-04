import SwiftUI

struct RecommendationView: View {
    @StateObject private var vm = RecommendationViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                metadataSection
                tableSection
            }
            .padding()
            .navigationTitle("Aanbeveling".localized)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save to Excel".localized) { vm.saveToExcel() }
                    Button("Share".localized) { vm.shareFile() }
                    Button(action: vm.addRow) { Image(systemName: "plus") }
                    Button("Clear".localized) { vm.clearDraft() }
                }
            }
            .sheet(item: $vm.shareURL) { url in
                ActivityView(activityItems: [url])
            }
            .onDisappear { vm.saveDraft() }
        }
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Plaas:".localized)
                TextField("", text: $vm.metadata.farm).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Agent:".localized)
                TextField("", text: $vm.metadata.agentName).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Datum:".localized)
                DatePicker("", selection: $vm.metadata.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
        }
    }

    private var tableSection: some View {
        ScrollView(.horizontal) {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                Section(header: header) {
                    ForEach($vm.rows) { $row in
                        HStack {
                            Button(action: { if let index = vm.rows.firstIndex(where: { $0.id == row.id }) { vm.deleteRow(at: IndexSet(integer: index)) } }) {
                                Image(systemName: "minus.circle.fill")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            TextField("Gewas".localized, text: $row.gewas).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                            TextField("Teiken".localized, text: $row.teiken).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                            TextField("Produk".localized, text: $row.produk).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Aktief".localized, text: $row.aktief).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Dosis/100 LT".localized, text: $row.dosis100LT).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                            TextField("Dosis/Ten K".localized, text: $row.dosisTenK).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                            TextField("OHP".localized, text: $row.ohp).textFieldStyle(.roundedBorder).frame(minWidth: 80)
                            TextField("Opmerkings".localized, text: $row.opmerkings).textFieldStyle(.roundedBorder).frame(minWidth: 200)
                        }
                    }
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Spacer().frame(width: 24)
            Group {
                Text("Gewas".localized).frame(minWidth: 100)
                Text("Teiken".localized).frame(minWidth: 100)
                Text("Produk".localized).frame(minWidth: 120)
                Text("Aktief".localized).frame(minWidth: 120)
                Text("Dosis/100 LT".localized).frame(minWidth: 100)
                Text("Dosis/Ten K".localized).frame(minWidth: 100)
                Text("OHP".localized).frame(minWidth: 80)
                Text("Opmerkings".localized).frame(minWidth: 200)
            }
            .bold()
        }
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.1))
    }
}
