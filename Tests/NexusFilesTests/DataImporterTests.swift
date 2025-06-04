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
}
