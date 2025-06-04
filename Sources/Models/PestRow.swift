import Foundation

struct PestRow: Identifiable, Codable {
    var id = UUID()
    var trekker: String = ""
    var rat: String = ""
    var revs: String = ""
    var tyd: String = ""
    var pomp: String = ""
    var druk: String = ""
}

struct WeedRow: Identifiable, Codable {
    var id = UUID()
    var trekker: String = ""
    var rat: String = ""
    var revs: String = ""
    var tyd: String = ""
    var pomp: String = ""
    var druk: String = ""
}
