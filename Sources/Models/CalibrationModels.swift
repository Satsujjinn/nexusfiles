import Foundation

struct CalibrationMetadata: Codable {
    var producer: String = ""
    var farm: String = ""
    var selectedDate: Date = Date()
    var agentName: String = "T. JORDAAN"
    var crop: String = ""
}

struct CalibrationRow: Identifiable, Codable {
    var id = UUID()
    var trekker: String = ""
    var rat: String = ""
    var revs: String = ""
    var tyd: String = ""
    var pomp: String = ""
    var druk: String = ""
    var aantalSputkoppe: String = ""
    var tipeSputkop: String = ""
    var lewering: String = ""
    var water: String = ""
}
