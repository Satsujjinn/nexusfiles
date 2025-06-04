import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var categories: [Category] = []
    private let fileManager = FileManager.default
    private var categoriesURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Categories")
    }

    init() {
        loadCategories()
    }

    func loadCategories() {
        do {
            let dataURL = categoriesURL.appendingPathComponent("categories.json")
            if fileManager.fileExists(atPath: dataURL.path) {
                let data = try Data(contentsOf: dataURL)
                categories = try JSONDecoder().decode([Category].self, from: data)
            }
        } catch {
            print("Load error: \(error)")
        }
    }

    func saveCategories() {
        do {
            try fileManager.createDirectory(at: categoriesURL, withIntermediateDirectories: true)
            let dataURL = categoriesURL.appendingPathComponent("categories.json")
            let data = try JSONEncoder().encode(categories)
            try data.write(to: dataURL)
        } catch {
            print("Save error: \(error)")
        }
    }

    func addCategory(name: String, icon: String) {
        let category = Category(name: name, icon: icon)
        categories.append(category)
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
