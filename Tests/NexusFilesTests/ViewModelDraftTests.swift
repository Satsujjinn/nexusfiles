import XCTest
@testable import NexusFiles

final class ViewModelDraftTests: XCTestCase {
    func testTractorInfoPersistence() throws {
        let vm = TractorInfoViewModel()
        vm.pests = [PestRow(trekker: "T", rat: "1", revs: "2", tyd: "3", pomp: "4", druk: "5")]
        vm.saveDraft()
        let vm2 = TractorInfoViewModel()
        XCTAssertEqual(vm2.pests.count, 1)
        vm.clearDraft()
    }

    func testCalibrationPersistence() throws {
        var row = CalibrationRow()
        row.trekker = "A"
        let vm = CalibrationViewModel()
        vm.rows = [row]
        vm.saveDraft()
        let vm2 = CalibrationViewModel()
        XCTAssertEqual(vm2.rows.count, 1)
        vm.clearDraft()
    }

    func testRecommendationPersistence() throws {
        var row = RecommendationRow()
        row.gewas = "Corn"
        let vm = RecommendationViewModel()
        vm.rows = [row]
        vm.saveDraft()
        let vm2 = RecommendationViewModel()
        XCTAssertEqual(vm2.rows.count, 1)
        vm.clearDraft()
    }
}
