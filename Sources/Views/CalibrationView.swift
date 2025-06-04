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
            .navigationTitle("Kalibrasie")
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
                Text("Produisent:")
                TextField("", text: $vm.metadata.producer).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Plaas:")
                TextField("", text: $vm.metadata.farm).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Datum:")
                DatePicker("", selection: $vm.metadata.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
            HStack {
                Text("Agent:")
                TextField("", text: $vm.metadata.agentName).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Gewas:")
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
                            TextField("Trekker", text: $row.trekker).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                            TextField("Rat", text: $row.rat).textFieldStyle(.roundedBorder).frame(minWidth: 60)
                            TextField("Revs", text: $row.revs).textFieldStyle(.roundedBorder).frame(minWidth: 60)
                            TextField("Tyd oor toetsafstand", text: $row.tyd).textFieldStyle(.roundedBorder).frame(minWidth: 150)
                            TextField("Pomp", text: $row.pomp).textFieldStyle(.roundedBorder).frame(minWidth: 80)
                            TextField("Druk", text: $row.druk).textFieldStyle(.roundedBorder).frame(minWidth: 80)
                            TextField("Aantal Sputkoppe", text: $row.aantalSputkoppe).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Tipe Sputkop", text: $row.tipeSputkop).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Lewering (L/ha)", text: $row.lewering).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Water", text: $row.water).textFieldStyle(.roundedBorder).frame(minWidth: 80)
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
                Text("Trekker").frame(minWidth: 100)
                Text("Rat").frame(minWidth: 60)
                Text("Revs").frame(minWidth: 60)
                Text("Tyd oor toetsafstand").frame(minWidth: 150)
                Text("Pomp").frame(minWidth: 80)
                Text("Druk").frame(minWidth: 80)
                Text("Aantal Sputkoppe").frame(minWidth: 120)
                Text("Tipe Sputkop").frame(minWidth: 120)
                Text("Lewering (L/ha)").frame(minWidth: 120)
                Text("Water").frame(minWidth: 80)
            }
            .bold()
        }
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.1))
    }
}
