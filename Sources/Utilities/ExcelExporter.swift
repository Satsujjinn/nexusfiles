import Foundation
import os
#if canImport(xlsxwriter)
import xlsxwriter
#endif

enum ExcelExporterError: Error {
    case libraryUnavailable
}

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

#if canImport(xlsxwriter)
    static func exportTractorInfo(pestRows: [PestRow], weedRows: [WeedRow]) throws -> URL {
        let fileURL = documentsURL(filename: "NexusFiles_TractorInfo_\(isoDateString()).xlsx")
        let workbook = Workbook(fileURL.path)
        defer { workbook.close() }

        var worksheet = workbook.addWorksheet(name: "Pest Control")
        write(rows: pestRows.map { [$0.trekker, $0.rat, $0.revs, $0.tyd, $0.pomp, $0.druk] },
              headers: ["Tractor", "Gear", "RPM", "Time over distance", "Pump", "Pressure"],
              to: &worksheet)

        worksheet = workbook.addWorksheet(name: "Weed Control")
        write(rows: weedRows.map { [$0.trekker, $0.rat, $0.revs, $0.tyd, $0.pomp, $0.druk] },
              headers: ["Tractor", "Gear", "RPM", "Time over distance", "Pump", "Pressure"],
              to: &worksheet)

        Log.general.info("Excel saved to \(fileURL.path, privacy: .public)")
        return fileURL
    }

    static func exportCalibration(metadata: CalibrationMetadata, rows: [CalibrationRow]) throws -> URL {
        let fileURL = documentsURL(filename: "NexusFiles_Calibration_\(isoDateString()).xlsx")
        let workbook = Workbook(fileURL.path)
        defer { workbook.close() }

        var sheet = workbook.addWorksheet(name: "Calibration")
        var rowIndex = 0
        sheet.writeString(row: rowIndex, column: 0, string: "Producer")
        sheet.writeString(row: rowIndex, column: 1, string: metadata.producer)
        rowIndex += 1
        sheet.writeString(row: rowIndex, column: 0, string: "Farm")
        sheet.writeString(row: rowIndex, column: 1, string: metadata.farm)
        rowIndex += 1
        sheet.writeString(row: rowIndex, column: 0, string: "Date")
        sheet.writeString(row: rowIndex, column: 1, string: isoDateString(metadata.selectedDate))
        rowIndex += 1
        sheet.writeString(row: rowIndex, column: 0, string: "Agent")
        sheet.writeString(row: rowIndex, column: 1, string: metadata.agentName)
        rowIndex += 1
        sheet.writeString(row: rowIndex, column: 0, string: "Crop")
        sheet.writeString(row: rowIndex, column: 1, string: metadata.crop)
        rowIndex += 2

        let headers = ["Tractor", "Gear", "RPM", "Time over distance", "Pump", "Pressure", "Nozzles", "Nozzle Type", "Output (L/ha)", "Water"]
        for (i, header) in headers.enumerated() {
            sheet.writeString(row: rowIndex, column: lxw_col_t(i), string: header)
        }
        rowIndex += 1

        for r in rows {
            let values = [r.trekker, r.rat, r.revs, r.tyd, r.pomp, r.druk, r.aantalSputkoppe, r.tipeSputkop, r.lewering, r.water]
            for (c, v) in values.enumerated() {
                sheet.writeString(row: rowIndex, column: lxw_col_t(c), string: v)
            }
            rowIndex += 1
        }

        Log.general.info("Excel saved to \(fileURL.path, privacy: .public)")
        return fileURL
    }
    static func exportRecommendation(metadata: RecommendationMetadata, rows: [RecommendationRow]) throws -> URL {
        let fileURL = documentsURL(filename: "NexusFiles_Recommendation_\(isoDateString()).xlsx")
        let workbook = Workbook(fileURL.path)
        defer { workbook.close() }

        var sheet = workbook.addWorksheet(name: "Recommendation")
        var rowIndex = 0
        sheet.writeString(row: rowIndex, column: 0, string: "Farm")
        sheet.writeString(row: rowIndex, column: 1, string: metadata.farm)
        rowIndex += 1
        sheet.writeString(row: rowIndex, column: 0, string: "Agent")
        sheet.writeString(row: rowIndex, column: 1, string: metadata.agentName)
        rowIndex += 1
        sheet.writeString(row: rowIndex, column: 0, string: "Date")
        sheet.writeString(row: rowIndex, column: 1, string: isoDateString(metadata.selectedDate))
        rowIndex += 2

        let headers = ["Crop", "Target", "Product", "Active", "Dose/100 L", "Dose/Ten K", "OHP", "Notes"]
        for (i, header) in headers.enumerated() {
            sheet.writeString(row: rowIndex, column: lxw_col_t(i), string: header)
        }
        rowIndex += 1

        for r in rows {
            let values = [r.gewas, r.teiken, r.produk, r.aktief, r.dosis100LT, r.dosisTenK, r.ohp, r.opmerkings]
            for (c, v) in values.enumerated() {
                sheet.writeString(row: rowIndex, column: lxw_col_t(c), string: v)
            }
            rowIndex += 1
        }

        Log.general.info("Excel saved to \(fileURL.path, privacy: .public)")
        return fileURL
    }

    private static func write(rows: [[String]], headers: [String], to sheet: inout Worksheet) {
        for (i, header) in headers.enumerated() {
            sheet.writeString(row: 0, column: lxw_col_t(i), string: header)
        }
        for (rowIndex, row) in rows.enumerated() {
            for (colIndex, value) in row.enumerated() {
                sheet.writeString(row: rowIndex + 1, column: lxw_col_t(colIndex), string: value)
            }
        }
    }
#else
    static func exportTractorInfo(pestRows: [PestRow], weedRows: [WeedRow]) throws -> URL {
        throw ExcelExporterError.libraryUnavailable
    }

    static func exportCalibration(metadata: CalibrationMetadata, rows: [CalibrationRow]) throws -> URL {
        throw ExcelExporterError.libraryUnavailable
    }

    static func exportRecommendation(metadata: RecommendationMetadata, rows: [RecommendationRow]) throws -> URL {
        throw ExcelExporterError.libraryUnavailable
    }
#endif
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
