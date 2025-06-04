import Foundation
import SwiftUI

final class CalibrationViewModel: ObservableObject {
    @Published var metadata = CalibrationMetadata()
    @Published var rows: [CalibrationRow] = []
    @Published var shareURL: URL?

    private var draftURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("CalibrationDraft.json")
    }
    private var iCloudURL: URL? {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("CalibrationDraft.json")
    }

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
        metadata = CalibrationMetadata()
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
