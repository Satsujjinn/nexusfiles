import Foundation
import SwiftUI

final class TractorInfoViewModel: ObservableObject {
    @Published var pests: [PestRow] = []
    @Published var weeds: [WeedRow] = []
    @Published var shareURL: URL?

    func addPestRow() { pests.append(PestRow()) }
    func deletePest(at offsets: IndexSet) { pests.remove(atOffsets: offsets) }

    func addWeedRow() { weeds.append(WeedRow()) }
    func deleteWeed(at offsets: IndexSet) { weeds.remove(atOffsets: offsets) }

    func saveToExcel() {
        do {
            shareURL = try ExcelExporter.exportTractorInfo(pestRows: pests, weedRows: weeds)
        } catch {
            print("Save error: \(error)")
        }
    }

    func shareFile() {
        if shareURL == nil { saveToExcel() }
    }
}
