import Foundation
import os

struct ExcelExporter {
    static func isoDateString(_ date: Date = Date()) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: date)
    }

    static func documentsURL(filename: String) -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent(filename)
    }

    static func exportTractorInfo(pestRows: [PestRow], weedRows: [WeedRow]) throws -> URL {
        let fileURL = documentsURL(filename: "NexusFiles2025_TractorInfo_\(isoDateString()).csv")
        let headers = ["Trekker", "Rat", "Revs", "Tyd", "Pomp", "Druk"]
        var rows: [[String]] = pestRows.map { [$0.trekker, $0.rat, $0.revs, $0.tyd, $0.pomp, $0.druk] }
        rows.append(contentsOf: weedRows.map { [$0.trekker, $0.rat, $0.revs, $0.tyd, $0.pomp, $0.druk] })
        let csv = makeCSV(rows: rows, headers: headers)
        try csv.write(to: fileURL, atomically: true, encoding: .utf8)
        Log.general.info("CSV saved to \(fileURL.path, privacy: .public)")
        return fileURL
    }

    static func exportCalibration(metadata: CalibrationMetadata, rows: [CalibrationRow]) throws -> URL {
        let fileURL = documentsURL(filename: "NexusFiles2025_Calibration_\(isoDateString()).csv")
        var csv = "Producer,\(metadata.producer)\n"
        csv += "Farm,\(metadata.farm)\n"
        csv += "Date,\(isoDateString(metadata.selectedDate))\n"
        csv += "Agent,\(metadata.agentName)\n"
        csv += "Crop,\(metadata.crop)\n\n"
        let headers = ["Tractor", "Gear", "RPM", "Time over distance", "Pump", "Pressure", "Nozzles", "Nozzle Type", "Output (L/ha)", "Water"]
        let data = rows.map { [ $0.trekker, $0.rat, $0.revs, $0.tyd, $0.pomp, $0.druk, $0.aantalSputkoppe, $0.tipeSputkop, $0.lewering, $0.water ] }
        csv += makeCSV(rows: data, headers: headers)
        try csv.write(to: fileURL, atomically: true, encoding: .utf8)
        Log.general.info("CSV saved to \(fileURL.path, privacy: .public)")
        return fileURL
    }

    static func exportRecommendation(metadata: RecommendationMetadata, rows: [RecommendationRow]) throws -> URL {
        let fileURL = documentsURL(filename: "NexusFiles2025_Recommendation_\(isoDateString()).csv")
        var csv = "Farm,\(metadata.farm)\n"
        csv += "Agent,\(metadata.agentName)\n"
        csv += "Date,\(isoDateString(metadata.selectedDate))\n\n"
        let headers = ["Crop", "Target", "Product", "Active", "Dose/100 L", "Dose/Ten K", "OHP", "Notes"]
        let data = rows.map { [ $0.gewas, $0.teiken, $0.produk, $0.aktief, $0.dosis100LT, $0.dosisTenK, $0.ohp, $0.opmerkings ] }
        csv += makeCSV(rows: data, headers: headers)
        try csv.write(to: fileURL, atomically: true, encoding: .utf8)
        Log.general.info("CSV saved to \(fileURL.path, privacy: .public)")
        return fileURL
    }

    private static func makeCSV(rows: [[String]], headers: [String]) -> String {
        var csv = headers.joined(separator: ",") + "\n"
        for row in rows {
            csv += row.joined(separator: ",") + "\n"
        }
        return csv
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
