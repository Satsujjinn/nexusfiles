import Foundation
import SwiftUI

/// Manages the list of categories shown on the Home screen and handles
/// persistence of category metadata and folders.

final class HomeViewModel: ObservableObject {
    @Published var categories: [Category] = []
    private let fileManager = FileManager.default
    private var categoriesURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Categories")
    }
    private var dataURL: URL { categoriesURL.appendingPathComponent("categories.json") }

    init() {
        loadCategories()
    }

    func loadCategories() {
        do {
            if fileManager.fileExists(atPath: dataURL.path) {
                categories = try FileStorage.load([Category].self, from: dataURL)
            }
            categories.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        } catch {
            print("Load error: \(error)")
        }
    }

    func saveCategories() {
        do {
            try FileStorage.save(categories, to: dataURL)
        } catch {
            print("Save error: \(error)")
        }
    }

    func addCategory(name: String, icon: String) {
        let category = Category(name: name, icon: icon)
        categories.append(category)
        categories.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        saveCategories()
        createFolder(for: category)
    }

    func deleteCategory(at offsets: IndexSet) {
        let removed = offsets.map { categories[$0] }
        categories.remove(atOffsets: offsets)
        saveCategories()
        for cat in removed {
            removeFolder(for: cat)
        }
    }

    func renameCategory(id: UUID, name: String, icon: String) {
        guard let index = categories.firstIndex(where: { $0.id == id }) else { return }
        categories[index].name = name
        categories[index].icon = icon
        categories.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        saveCategories()
    }

    private func folderURL(for category: Category) -> URL {
        categoriesURL.appendingPathComponent(category.id.uuidString)
    }

    func folderURL(for id: UUID) -> URL {
        categoriesURL.appendingPathComponent(id.uuidString)
    }

    private func createFolder(for category: Category) {
        do {
            try fileManager.createDirectory(at: folderURL(for: category), withIntermediateDirectories: true)
        } catch {
            print("Folder creation error: \(error)")
        }
    }

    private func removeFolder(for category: Category) {
        do {
            try fileManager.removeItem(at: folderURL(for: category))
        } catch {
            print("Folder remove error: \(error)")
        }
    }
}
