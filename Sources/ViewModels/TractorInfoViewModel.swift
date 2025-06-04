import Foundation
import SwiftUI

final class TractorInfoViewModel: ObservableObject {
    @Published var pests: [PestRow] = []
    @Published var weeds: [WeedRow] = []
    @Published var shareURL: URL?

    private var draftURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("TractorInfoDraft.json")
    }
    private var iCloudURL: URL? {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("TractorInfoDraft.json")
    }

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
            try FileStorage.save(Draft(pests: pests, weeds: weeds), to: draftURL)
        } catch {
            print("Save error: \(error)")
        }
    }

    func saveDraft() {
        try? FileStorage.save(Draft(pests: pests, weeds: weeds), to: draftURL)
        if let cloud = iCloudURL { try? FileStorage.save(Draft(pests: pests, weeds: weeds), to: cloud) }
    }

    func shareFile() {
        if shareURL == nil { saveToExcel() }
    }

    func clearDraft() {
        try? FileManager.default.removeItem(at: draftURL)
        if let cloud = iCloudURL { try? FileManager.default.removeItem(at: cloud) }
        pests.removeAll()
        weeds.removeAll()
    }

    private func loadDraft() {
        do {
            if FileManager.default.fileExists(atPath: draftURL.path) {
                let draft = try FileStorage.load(Draft.self, from: draftURL)
                pests = draft.pests
                weeds = draft.weeds
            }
        } catch {
            print("Load error: \(error)")
        }
    }
}
