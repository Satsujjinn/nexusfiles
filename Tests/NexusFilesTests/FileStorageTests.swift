import XCTest
@testable import NexusFiles

final class FileStorageTests: XCTestCase {
    struct Dummy: Codable, Equatable { var value: Int }

    func testSaveAndLoad() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("dummy.json")
        let data = Dummy(value: 42)
        try FileStorage.save(data, to: url)
        let loaded: Dummy = try FileStorage.load(Dummy.self, from: url)
        XCTAssertEqual(loaded, data)
    }
}
