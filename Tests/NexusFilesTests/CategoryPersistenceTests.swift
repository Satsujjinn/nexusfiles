import XCTest
@testable import NexusFiles

final class CategoryPersistenceTests: XCTestCase {
    func testSaveAndLoadCategories() async throws {
        let vm = HomeViewModel()
        vm.addCategory(name: "Test", icon: "folder", color: "red")
        try await Task.sleep(nanoseconds: 100_000_000)
        let vm2 = HomeViewModel()
        await Task.yield()
        XCTAssert(vm2.categories.contains { $0.name == "Test" })
        if let idx = vm.categories.firstIndex(where: { $0.name == "Test" }) {
            vm.deleteCategory(at: IndexSet(integer: idx))
        }
    }

    func testAddDuplicateCategoryDoesNotCreateDuplicate() throws {
        let vm = HomeViewModel()
        vm.addCategory(name: "Dup", icon: "folder")
        vm.addCategory(name: "Dup", icon: "folder")
        let count = vm.categories.filter { $0.name == "Dup" }.count
        XCTAssertEqual(count, 1)
        if let idx = vm.categories.firstIndex(where: { $0.name == "Dup" }) {
            vm.deleteCategory(at: IndexSet(integer: idx))
        }
    }
}
