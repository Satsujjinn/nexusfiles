import XCTest
@testable import NexusFiles

final class PDFExporterTests: XCTestCase {
    func testConversionCreatesPDFFile() throws {
        let tmp = FileManager.default.temporaryDirectory
        let excel = tmp.appendingPathComponent("sample.xlsx")
        FileManager.default.createFile(atPath: excel.path, contents: Data(), attributes: nil)
        let pdf = try PDFExporter.convertExcelToPDF(url: excel)
        XCTAssertTrue(FileManager.default.fileExists(atPath: pdf.path))
    }
}
