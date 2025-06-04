import Foundation

/// Logging helper
import os

/// Simple utility for loading and saving Codable values to disk.
struct FileStorage {
    /// Load a Codable value from a file URL.
    static func load<T: Decodable>(_ type: T.Type, from url: URL) throws -> T {
        let data = try Data(contentsOf: url)
        let value = try JSONDecoder().decode(T.self, from: data)
        Log.general.debug("Loaded \(url.lastPathComponent, privacy: .public)")
        return value
    }

    /// Save a Codable value to a file URL.
    static func save<T: Encodable>(_ value: T, to url: URL) throws {
        let data = try JSONEncoder().encode(value)
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: url, options: .atomic)
        Log.general.debug("Saved \(url.lastPathComponent, privacy: .public)")
    }
}
