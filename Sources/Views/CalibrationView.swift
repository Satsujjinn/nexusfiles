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
            .navigationTitle("Calibration".localized)
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
            .applyAppTheme()
        }
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Producer:".localized)
                TextField("", text: $vm.metadata.producer).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Farm:".localized)
                TextField("", text: $vm.metadata.farm).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Date:".localized)
                DatePicker("", selection: $vm.metadata.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
            HStack {
                Text("Agent:".localized)
                TextField("", text: $vm.metadata.agentName).textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Crop:".localized)
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
                            TextField("Tractor".localized, text: $row.trekker).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                            TextField("Gear".localized, text: $row.rat).textFieldStyle(.roundedBorder).frame(minWidth: 60)
                            TextField("RPM".localized, text: $row.revs).textFieldStyle(.roundedBorder).frame(minWidth: 60)
                            TextField("Time over distance".localized, text: $row.tyd).textFieldStyle(.roundedBorder).frame(minWidth: 150)
                            TextField("Pump".localized, text: $row.pomp).textFieldStyle(.roundedBorder).frame(minWidth: 80)
                            TextField("Pressure".localized, text: $row.druk).textFieldStyle(.roundedBorder).frame(minWidth: 80)
                            TextField("Nozzles".localized, text: $row.aantalSputkoppe).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Nozzle Type".localized, text: $row.tipeSputkop).textFieldStyle(.roundedBorder).frame(minWidth: 120)
                            TextField("Output (L/ha)".localized, text: $row.lewering).textFieldStyle(.roundedBorder).frame(minWidth: 120)
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
                Text("Tractor".localized).frame(minWidth: 100)
                Text("Gear".localized).frame(minWidth: 60)
                Text("RPM".localized).frame(minWidth: 60)
                Text("Time over distance".localized).frame(minWidth: 150)
                Text("Pump".localized).frame(minWidth: 80)
                Text("Pressure".localized).frame(minWidth: 80)
                Text("Nozzles".localized).frame(minWidth: 120)
                Text("Nozzle Type".localized).frame(minWidth: 120)
                Text("Output (L/ha)".localized).frame(minWidth: 120)
                Text("Water".localized).frame(minWidth: 80)
            }
            .bold()
        }
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.1))
    }
}
