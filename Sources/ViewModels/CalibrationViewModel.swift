import Foundation
import SwiftUI

final class CalibrationViewModel: ObservableObject {
    @Published var metadata = CalibrationMetadata()
    @Published var rows: [CalibrationRow] = []
    @Published var shareURL: URL?

    func addRow() { rows.append(CalibrationRow()) }
    func deleteRow(at offsets: IndexSet) { rows.remove(atOffsets: offsets) }

    func saveToExcel() {
        do {
            shareURL = try ExcelExporter.exportCalibration(metadata: metadata, rows: rows)
        } catch {
            print("Save error: \(error)")
        }
    }

    func shareFile() { if shareURL == nil { saveToExcel() } }
}
