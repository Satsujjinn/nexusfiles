import XCTest
@testable import NexusFiles

final class DataImporterTests: XCTestCase {
    func testParseTractorCSV() throws {
        let data = "Trekker,Rat,Revs,Tyd,Pomp,Druk\nA,1,2,3,4,5"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("tractor.csv")
        try data.write(to: url, atomically: true, encoding: .utf8)
        let (pests, _) = try DataImporter.parseTractorInfo(url: url)
        XCTAssertEqual(pests.first?.trekker, "A")
    }

    func testParseTractorXLSX() throws {
        let row = PestRow(trekker: "B", rat: "1", revs: "2", tyd: "3", pomp: "4", druk: "5")
        let url = try ExcelExporter.exportTractorInfo(pestRows: [row], weedRows: [])
        let (pests, _) = try DataImporter.parseTractorInfo(url: url)
        XCTAssertEqual(pests.first?.trekker, "B")
    }
}
