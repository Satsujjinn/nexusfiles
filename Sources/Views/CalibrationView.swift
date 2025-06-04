import SwiftUI

struct CalibrationView: View {
    @StateObject private var vm = CalibrationViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                metadataSection
                tableSection
            }
            .padding()
            .navigationTitle("Kalibrasie".localized)
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
                Text("Produisent:".localized)
                TextField("", text: $vm.metadata.producer).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Plaas:".localized)
                TextField("", text: $vm.metadata.farm).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Datum:".localized)
                DatePicker("", selection: $vm.metadata.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
            HStack {
                Text("Agent:".localized)
                TextField("", text: $vm.metadata.agentName).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Gewas:".localized)
                TextField("", text: $vm.metadata.crop).textFieldStyle(.roundedBorder)
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
                            TextField("Trekker".localized, text: $row.trekker).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                            TextField("Rat".localized, text: $row.rat).textFieldStyle(.roundedBorder).frame(minWidth: 60)
                            TextField("Revs".localized, text: $row.revs).textFieldStyle(.roundedBorder).frame(minWidth: 60)
                            TextField("Tyd oor toetsafstand".localized, text: $row.tyd).textFieldStyle(.roundedBorder).frame(minWidth: 150)
                            TextField("Pomp".localized, text: $row.pomp).textFieldStyle(.roundedBorder).frame(minWidth: 80)
                            TextField("Druk".localized, text: $row.druk).textFieldStyle(.roundedBorder).frame(minWidth: 80)
                            TextField("Aantal Sputkoppe".localized, text: $row.aantalSputkoppe).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Tipe Sputkop".localized, text: $row.tipeSputkop).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Lewering (L/ha)".localized, text: $row.lewering).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Water".localized, text: $row.water).textFieldStyle(.roundedBorder).frame(minWidth: 80)
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
                Text("Trekker".localized).frame(minWidth: 100)
                Text("Rat".localized).frame(minWidth: 60)
                Text("Revs".localized).frame(minWidth: 60)
                Text("Tyd oor toetsafstand".localized).frame(minWidth: 150)
                Text("Pomp".localized).frame(minWidth: 80)
                Text("Druk".localized).frame(minWidth: 80)
                Text("Aantal Sputkoppe".localized).frame(minWidth: 120)
                Text("Tipe Sputkop".localized).frame(minWidth: 120)
                Text("Lewering (L/ha)".localized).frame(minWidth: 120)
                Text("Water".localized).frame(minWidth: 80)
            }
            .bold()
        }
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.1))
    }
}
