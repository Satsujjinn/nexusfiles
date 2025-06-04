import SwiftUI

struct TractorInfoView: View {
    @StateObject private var vm = TractorInfoViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    PestTable(title: "Plaagbeheer".localized, rows: $vm.pests, addAction: vm.addPestRow, deleteAction: vm.deletePest)
                    PestTable(title: "Onkruidbeheer".localized, rows: $vm.weeds, addAction: vm.addWeedRow, deleteAction: vm.deleteWeed)
                }
                .padding()
            }
            .navigationTitle("Trekkerinligting".localized)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save to Excel".localized) { vm.saveToExcel() }
                    Button("Share".localized) { vm.shareFile() }
                    Button("Clear".localized) { vm.clearDraft() }
                }
            }
            .sheet(item: $vm.shareURL) { url in
                ActivityView(activityItems: [url])
            }
            .onDisappear { vm.saveDraft() }
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
                                TextField("Trekker".localized, text: $row.trekker).textFieldStyle(.roundedBorder).frame(minWidth: 100)
                                TextField("Rat".localized, text: $row.rat).textFieldStyle(.roundedBorder).frame(minWidth: 60)
                                TextField("Revs".localized, text: $row.revs).textFieldStyle(.roundedBorder).frame(minWidth: 60)
                                TextField("Tyd oor toetsafstand".localized, text: $row.tyd).textFieldStyle(.roundedBorder).frame(minWidth: 150)
                                TextField("Pomp".localized, text: $row.pomp).textFieldStyle(.roundedBorder).frame(minWidth: 80)
                                TextField("Druk".localized, text: $row.druk).textFieldStyle(.roundedBorder).frame(minWidth: 80)
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
            Text("Trekker".localized).bold().frame(minWidth: 100)
            Text("Rat".localized).bold().frame(minWidth: 60)
            Text("Revs".localized).bold().frame(minWidth: 60)
            Text("Tyd oor toetsafstand".localized).bold().frame(minWidth: 150)
            Text("Pomp".localized).bold().frame(minWidth: 80)
            Text("Druk".localized).bold().frame(minWidth: 80)
        }
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.1))
    }
}
