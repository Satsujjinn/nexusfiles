import SwiftUI

struct TractorInfoView: View {
    @StateObject private var vm = TractorInfoViewModel()
    @State private var showImport = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    PestTable(title: "Pest Control".localized, rows: $vm.pests, addAction: vm.addPestRow, deleteAction: vm.deletePest)
                    PestTable(title: "Weed Control".localized, rows: $vm.weeds, addAction: vm.addWeedRow, deleteAction: vm.deleteWeed)
                }
                .padding()
            }
            .navigationTitle("Tractor Info".localized)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save to Excel".localized) { vm.saveToExcel() }
                    Button("Share".localized) { vm.shareFile() }
                    Button("Import".localized) { showImport = true }
                    Button("Clear".localized) { vm.clearDraft() }
                }
            }
            .sheet(item: $vm.shareURL) { url in
                ActivityView(activityItems: [url])
            }
            .fileImporter(isPresented: $showImport, allowedContentTypes: [.data]) { result in
                if case let .success(urls) = result, let first = urls.first {
                    vm.importData(from: first)
                }
            }
            .onDisappear { vm.saveDraft() }
            .applyAppTheme()
        }
    }
}

private struct PestTable: View {
    let title: String
    @Binding var rows: [PestRow]
    let addAction: () -> Void
    let deleteAction: (IndexSet) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Button(action: addAction) {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .padding(.bottom, 4)

            ScrollView(.horizontal) {
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    Section(header: header) {
                        ForEach($rows) { $row in
                            HStack(alignment: .center) {
                                Button(action: { if let index = rows.firstIndex(where: { $0.id == row.id }) { deleteAction(IndexSet(integer: index)) } }) {
                                    Image(systemName: "minus.circle.fill")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                TextField("Tractor".localized, text: $row.trekker).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                                TextField("Gear".localized, text: $row.rat).textFieldStyle(.roundedBorder).frame(minWidth: 60)
                                TextField("RPM".localized, text: $row.revs).textFieldStyle(.roundedBorder).frame(minWidth: 60)
                                TextField("Time over distance".localized, text: $row.tyd).textFieldStyle(.roundedBorder).frame(minWidth: 150)
                                TextField("Pump".localized, text: $row.pomp).textFieldStyle(.roundedBorder).frame(minWidth: 80)
                                TextField("Pressure".localized, text: $row.druk).textFieldStyle(.roundedBorder).frame(minWidth: 80)
                            }
                        }
                        .onDelete(perform: deleteAction)
                    }
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Spacer().frame(width: 24)
            Text("Tractor".localized).bold().frame(minWidth: 100)
            Text("Gear".localized).bold().frame(minWidth: 60)
            Text("RPM".localized).bold().frame(minWidth: 60)
            Text("Time over distance".localized).bold().frame(minWidth: 150)
            Text("Pump".localized).bold().frame(minWidth: 80)
            Text("Pressure".localized).bold().frame(minWidth: 80)
        }
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.1))
    }
}
