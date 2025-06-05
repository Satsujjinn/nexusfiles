import Foundation

/// A helper for loading and saving draft data locally and to iCloud if available.
struct DraftStorage<T: Codable> {
    private let fileManager = FileManager.default
    let localURL: URL
    let iCloudURL: URL?

    init(fileName: String) {
        self.localURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        if let cloud = fileManager.url(forUbiquityContainerIdentifier: nil) {
            self.iCloudURL = cloud.appendingPathComponent(fileName)
        } else {
            self.iCloudURL = nil
        }
    }

    func load() -> T? {
        do {
            if fileManager.fileExists(atPath: localURL.path) {
                return try FileStorage.load(T.self, from: localURL)
            }
            if let cloud = iCloudURL, fileManager.fileExists(atPath: cloud.path) {
                return try FileStorage.load(T.self, from: cloud)
            }
        } catch {
            print("Draft load error: \(error)")
        }
        return nil
    }

    func save(_ value: T) {
        do {
            try FileStorage.save(value, to: localURL)
            if let cloud = iCloudURL { try FileStorage.save(value, to: cloud) }
        } catch {
            print("Draft save error: \(error)")
        }
    }

    func clear() {
        try? fileManager.removeItem(at: localURL)
        if let cloud = iCloudURL { try? fileManager.removeItem(at: cloud) }
    }
}
