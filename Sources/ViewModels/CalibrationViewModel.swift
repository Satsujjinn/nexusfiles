import Foundation
import SwiftUI

final class CalibrationViewModel: ObservableObject {
    @Published var metadata = CalibrationMetadata()
    @Published var rows: [CalibrationRow] = []
    @Published var shareURL: URL?

    private let storage = DraftStorage<Draft>(fileName: "CalibrationDraft.json")

    struct Draft: Codable {
        var metadata: CalibrationMetadata
        var rows: [CalibrationRow]
    }

    init() {
        loadDraft()
    }

    func addRow() { rows.append(CalibrationRow()) }
    func deleteRow(at offsets: IndexSet) { rows.remove(atOffsets: offsets) }

    func saveToExcel() {
        do {
            shareURL = try ExcelExporter.exportCalibration(metadata: metadata, rows: rows)
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
        metadata = CalibrationMetadata()
        rows.removeAll()
    }

    private func loadDraft() {
        if let draft = storage.load() {
            metadata = draft.metadata
            rows = draft.rows
        }
    }
}
