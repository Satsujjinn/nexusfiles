import XCTest
@testable import NexusFiles

final class ImportViewModelTests: XCTestCase {
    func testTractorInfoImport() throws {
        let data = "Trekker,Rat,Revs,Tyd,Pomp,Druk\nA,1,2,3,4,5"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("tractorImport.csv")
        try data.write(to: url, atomically: true, encoding: .utf8)
        let vm = TractorInfoViewModel()
        vm.importData(from: url)
        XCTAssertEqual(vm.pests.first?.trekker, "A")
    }

    func testCalibrationImport() throws {
        let data = "Produisent,Plaas,Agent,Gewas\nP,F,A,G\nTrekker,Rat,Revs,Tyd,Pomp,Druk,Aantal Sputkoppe,Tipe Sputkop,Lewering (L/ha),Water\nA,1,2,3,4,5,6,7,8,9"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("cal.csv")
        try data.write(to: url, atomically: true, encoding: .utf8)
        let vm = CalibrationViewModel()
        vm.importData(from: url)
        XCTAssertEqual(vm.rows.first?.trekker, "A")
    }

    func testRecommendationImport() throws {
        let data = "Plaas,Agent\nF,A\nGewas,Teiken,Produk,Aktief,Dosis/100 LT,Dosis/Ten K,OHP,Opmerkings\nC,T,P,A,1,2,3,N"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("rec.csv")
        try data.write(to: url, atomically: true, encoding: .utf8)
        let vm = RecommendationViewModel()
        vm.importData(from: url)
        XCTAssertEqual(vm.rows.first?.gewas, "C")
    }
}
