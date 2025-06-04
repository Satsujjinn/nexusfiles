import Foundation

struct RecommendationMetadata {
    var farm: String = ""
    var agentName: String = ""
    var selectedDate: Date = Date()
}

struct RecommendationRow: Identifiable, Codable {
    var id = UUID()
    var gewas: String = ""
    var teiken: String = ""
    var produk: String = ""
    var aktief: String = ""
    var dosis100LT: String = ""
    var dosisTenK: String = ""
    var ohp: String = ""
    var opmerkings: String = ""
}
