import Foundation
import SwiftUI

/// Manages the list of categories shown on the Home screen and handles
/// persistence of category metadata and folders.
@MainActor
final class HomeViewModel: ObservableObject {
    @Published var categories: [Category] = []
    private let fileManager = FileManager.default
    private var iCloudURL: URL? {
        fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Categories")
    }
    private var categoriesURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Categories")
    }
    private var dataURL: URL { categoriesURL.appendingPathComponent("categories.json") }

    init() {
        Task { await loadCategories() }
    }

    var iCloudAvailable: Bool { fileManager.ubiquityIdentityToken != nil }

    func loadCategories() async {
        do {
            let loaded: [Category] = try await Task.detached { [dataURL] in
                if FileManager.default.fileExists(atPath: dataURL.path) {
                    return try FileStorage.load([Category].self, from: dataURL)
                }
                return []
            }.value
            categories = loaded.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            if categories.isEmpty {
                categories = defaultCategories()
                await saveCategories()
                for cat in categories { await createFolder(for: cat) }
            }
        } catch {
            print("Load error: \(error)")
        }
    }

    private func defaultCategories() -> [Category] {
        [
            Category(name: "Spuitprogramme".localized, icon: "doc"),
            Category(name: "MRL".localized, icon: "doc.text"),
            Category(name: "Etikette".localized, icon: "tag"),
            Category(name: "Kalibrasies".localized, icon: "wrench"),
            Category(name: "Aanbevelings".localized, icon: "list.bullet.rectangle"),
            Category(name: "Gewas Inligting".localized, icon: "leaf")
        ]
    }

    func saveCategories() async {
        do {
            let cats = categories
            try await Task.detached { [cats, dataURL, iCloudURL, iCloudAvailable, fileManager] in
                try FileStorage.save(cats, to: dataURL)
                if iCloudAvailable, let cloud = iCloudURL {
                    try fileManager.createDirectory(at: cloud.deletingLastPathComponent(), withIntermediateDirectories: true)
                    try FileStorage.save(cats, to: cloud.appendingPathComponent("categories.json"))
                }
            }.value
        } catch {
            print("Save error: \(error)")
        }
    }

    func addCategory(name: String, icon: String, color: String = "blue") {
        let category = Category(name: name, icon: icon, color: color)
        categories.append(category)
        categories.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        Task {
            await saveCategories()
            await createFolder(for: category)
        }
    }

    func deleteCategory(at offsets: IndexSet) {
        let removed = offsets.map { categories[$0] }
        categories.remove(atOffsets: offsets)
        Task {
            await saveCategories()
            for cat in removed { await removeFolder(for: cat) }
        }
    }

    func renameCategory(id: UUID, name: String, icon: String, color: String) {
        guard let index = categories.firstIndex(where: { $0.id == id }) else { return }
        categories[index].name = name
        categories[index].icon = icon
        categories[index].color = color
        categories.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        Task { await saveCategories() }
    }

    func moveCategory(from source: IndexSet, to destination: Int) {
        categories.move(fromOffsets: source, toOffset: destination)
        Task { await saveCategories() }
    }

    private func folderURL(for category: Category) -> URL {
        categoriesURL.appendingPathComponent(category.id.uuidString)
    }

    func folderURL(for id: UUID) -> URL {
        categoriesURL.appendingPathComponent(id.uuidString)
    }

    private func createFolder(for category: Category) async {
        do {
            let url = folderURL(for: category)
            try await Task.detached { try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true) }.value
        } catch {
            print("Folder creation error: \(error)")
        }
    }

    private func removeFolder(for category: Category) async {
        do {
            let url = folderURL(for: category)
            try await Task.detached { try FileManager.default.removeItem(at: url) }.value
        } catch {
            print("Folder remove error: \(error)")
        }
    }
}
