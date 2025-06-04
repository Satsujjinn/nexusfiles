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
            .navigationTitle("Aanbeveling")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save to Excel") { vm.saveToExcel() }
                    Button("Share") { vm.shareFile() }
                    Button(action: vm.addRow) { Image(systemName: "plus") }
                }
            }
            .sheet(item: $vm.shareURL) { url in
                ActivityView(activityItems: [url])
            }
        }
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Plaas:")
                TextField("", text: $vm.metadata.farm).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Agent:")
                TextField("", text: $vm.metadata.agentName).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Datum:")
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
                            TextField("Gewas", text: $row.gewas).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                            TextField("Teiken", text: $row.teiken).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                            TextField("Produk", text: $row.produk).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Aktief", text: $row.aktief).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Dosis/100 LT", text: $row.dosis100LT).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                            TextField("Dosis/Ten K", text: $row.dosisTenK).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                            TextField("OHP", text: $row.ohp).textFieldStyle(.roundedBorder).frame(minWidth: 80)
                            TextField("Opmerkings", text: $row.opmerkings).textFieldStyle(.roundedBorder).frame(minWidth: 200)
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
                Text("Gewas").frame(minWidth: 100)
                Text("Teiken").frame(minWidth: 100)
                Text("Produk").frame(minWidth: 120)
                Text("Aktief").frame(minWidth: 120)
                Text("Dosis/100 LT").frame(minWidth: 100)
                Text("Dosis/Ten K").frame(minWidth: 100)
                Text("OHP").frame(minWidth: 80)
                Text("Opmerkings").frame(minWidth: 200)
            }
            .bold()
        }
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.1))
    }
}
