import Foundation
import SwiftUI

final class RecommendationViewModel: ObservableObject {
    @Published var metadata = RecommendationMetadata()
    @Published var rows: [RecommendationRow] = []
    @Published var shareURL: URL?

    private let storage = DraftStorage<Draft>(fileName: "RecommendationDraft.json")

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
            storage.save(Draft(metadata: metadata, rows: rows))
        } catch {
            print("Save error: \(error)")
        }
    }

    func saveDraft() {
        storage.save(Draft(metadata: metadata, rows: rows))
    }

    func shareFile() { if shareURL == nil { saveToExcel() } }

    func clearDraft() {
        storage.clear()
        metadata = RecommendationMetadata()
        rows.removeAll()
    }

    func importData(from url: URL) {
        do {
            let (meta, rows) = try DataImporter.parseRecommendation(url: url)
            self.metadata = meta
            self.rows = rows
        } catch {
            print("Import error: \(error)")
        }
    }

    private func loadDraft() {
        if let draft = storage.load() {
            metadata = draft.metadata
            rows = draft.rows
        }
    }
}
