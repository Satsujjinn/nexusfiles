import Foundation
import SwiftUI

final class RecommendationViewModel: ObservableObject {
    @Published var metadata = RecommendationMetadata()
    @Published var rows: [RecommendationRow] = []
    @Published var shareURL: URL?

    private var draftURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("RecommendationDraft.json")
    }
    private var iCloudURL: URL? {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("RecommendationDraft.json")
    }

    struct Draft: Codable {
        var metadata: RecommendationMetadata
        var rows: [RecommendationRow]
    }

    init() {
        loadDraft()
    }

    func addRow() { rows.append(RecommendationRow()) }
    func deleteRow(at offsets: IndexSet) { rows.remove(atOffsets: offsets) }

    func saveToExcel() {
        do {
            shareURL = try ExcelExporter.exportRecommendation(metadata: metadata, rows: rows)
            try FileStorage.save(Draft(metadata: metadata, rows: rows), to: draftURL)
        } catch {
            print("Save error: \(error)")
        }
    }

    func saveDraft() {
        try? FileStorage.save(Draft(metadata: metadata, rows: rows), to: draftURL)
        if let cloud = iCloudURL { try? FileStorage.save(Draft(metadata: metadata, rows: rows), to: cloud) }
    }

    func shareFile() { if shareURL == nil { saveToExcel() } }

    func clearDraft() {
        try? FileManager.default.removeItem(at: draftURL)
        if let cloud = iCloudURL { try? FileManager.default.removeItem(at: cloud) }
        metadata = RecommendationMetadata()
        rows.removeAll()
    }

    private func loadDraft() {
        do {
            if FileManager.default.fileExists(atPath: draftURL.path) {
                let draft = try FileStorage.load(Draft.self, from: draftURL)
                metadata = draft.metadata
                rows = draft.rows
            }
        } catch {
            print("Load error: \(error)")
        }
    }
}
