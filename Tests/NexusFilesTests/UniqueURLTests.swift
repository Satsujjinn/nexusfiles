import XCTest
@testable import NexusFiles

final class UniqueURLTests: XCTestCase {
    func testUniqueURLAddsIncrement() throws {
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let category = Category(name: "Temp", icon: "doc")
        var view = CategoryView(category: category, baseURL: tempDir)
        let original = tempDir.appendingPathComponent("file.txt")
        FileManager.default.createFile(atPath: original.path, contents: Data())

        let first = view.uniqueURL(for: original)
        XCTAssertEqual(first.lastPathComponent, "file-1.txt")
        FileManager.default.createFile(atPath: first.path, contents: Data())

        let second = view.uniqueURL(for: original)
        XCTAssertEqual(second.lastPathComponent, "file-2.txt")
    }
}
