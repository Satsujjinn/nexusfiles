import XCTest
@testable import NexusFiles

final class ExcelExporterTests: XCTestCase {
    func testIsoDateString() {
        let str = ExcelExporter.isoDateString(Date(timeIntervalSince1970: 0))
        XCTAssertTrue(str.contains("1970"))
    }
}
