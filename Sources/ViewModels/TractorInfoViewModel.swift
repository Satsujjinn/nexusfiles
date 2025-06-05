import Foundation
import SwiftUI

final class TractorInfoViewModel: ObservableObject {
    @Published var pests: [PestRow] = []
    @Published var weeds: [WeedRow] = []
    @Published var shareURL: URL?

    private let storage = DraftStorage<Draft>(fileName: "TractorInfoDraft.json")

    struct Draft: Codable {
        var pests: [PestRow]
        var weeds: [WeedRow]
    }

    init() {
        loadDraft()
    }

    func addPestRow() { pests.append(PestRow()) }
    func deletePest(at offsets: IndexSet) { pests.remove(atOffsets: offsets) }

    func addWeedRow() { weeds.append(WeedRow()) }
    func deleteWeed(at offsets: IndexSet) { weeds.remove(atOffsets: offsets) }

    func saveToExcel() {
        do {
            shareURL = try ExcelExporter.exportTractorInfo(pestRows: pests, weedRows: weeds)
            storage.save(Draft(pests: pests, weeds: weeds))
        } catch {
            print("Save error: \(error)")
        }
    }

    func saveDraft() {
        storage.save(Draft(pests: pests, weeds: weeds))
    }

    func shareFile() {
        if shareURL == nil { saveToExcel() }
    }

    func clearDraft() {
        storage.clear()
        pests.removeAll()
        weeds.removeAll()
    }

    private func loadDraft() {
        if let draft = storage.load() {
            pests = draft.pests
            weeds = draft.weeds
        }
    }
}
