import Foundation
import SwiftUI

final class RecommendationViewModel: ObservableObject {
    @Published var metadata = RecommendationMetadata()
    @Published var rows: [RecommendationRow] = []
    @Published var shareURL: URL?

    func addRow() { rows.append(RecommendationRow()) }
    func deleteRow(at offsets: IndexSet) { rows.remove(atOffsets: offsets) }

    func saveToExcel() {
        do {
            shareURL = try ExcelExporter.exportRecommendation(metadata: metadata, rows: rows)
        } catch {
            print("Save error: \(error)")
        }
    }

    func shareFile() { if shareURL == nil { saveToExcel() } }
}
