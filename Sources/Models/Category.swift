import Foundation

struct Category: Identifiable, Codable {
    let id: UUID
    var name: String
    var icon: String
    var color: String

    init(id: UUID = UUID(), name: String, icon: String, color: String = "blue") {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
    }
}
