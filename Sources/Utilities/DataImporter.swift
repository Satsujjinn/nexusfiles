import Foundation
import SwiftCSV
import CoreXLSX

enum ImportError: Error {
    case unsupportedFormat
    case invalidData
}

struct DataImporter {
    static func parseTractorInfo(url: URL) throws -> ([PestRow], [WeedRow]) {
        if url.pathExtension.lowercased() == "csv" {
            let csv = try CSV(url: url)
            var pests: [PestRow] = []
            for row in csv.namedRows {
                var p = PestRow()
                p.trekker = row["Trekker"] ?? ""
                p.rat = row["Rat"] ?? ""
                p.revs = row["Revs"] ?? ""
                p.tyd = row["Tyd"] ?? ""
                p.pomp = row["Pomp"] ?? ""
                p.druk = row["Druk"] ?? ""
                pests.append(p)
            }
            return (pests, [])
        } else if url.pathExtension.lowercased() == "xlsx" {
            guard let file = XLSXFile(filepath: url.path) else { throw ImportError.invalidData }
            guard let path = try file.parseWorksheetPaths().first,
                  let sheet = try file.parseWorksheet(at: path) else {
                throw ImportError.invalidData
            }
            var rows: [PestRow] = []
            for row in sheet.data?.rows.dropFirst() ?? [] { // skip header
                var r = PestRow()
                let c = row.cells
                if c.count >= 6 {
                    r.trekker = c[0].stringValue ?? ""
                    r.rat = c[1].stringValue ?? ""
                    r.revs = c[2].stringValue ?? ""
                    r.tyd = c[3].stringValue ?? ""
                    r.pomp = c[4].stringValue ?? ""
                    r.druk = c[5].stringValue ?? ""
                }
                rows.append(r)
            }
            return (rows, [])
        }
        throw ImportError.unsupportedFormat
    }

    static func parseCalibration(url: URL) throws -> (CalibrationMetadata, [CalibrationRow]) {
        if url.pathExtension.lowercased() == "csv" {
            let csv = try CSV(url: url)
            var metadata = CalibrationMetadata()
            var rows: [CalibrationRow] = []
            if let first = csv.namedRows.first {
                metadata.producer = first["Produisent"] ?? ""
                metadata.farm = first["Plaas"] ?? ""
                metadata.agentName = first["Agent"] ?? ""
                metadata.crop = first["Gewas"] ?? ""
            }
            for row in csv.namedRows.dropFirst() {
                var r = CalibrationRow()
                r.trekker = row["Trekker"] ?? ""
                r.rat = row["Rat"] ?? ""
                r.revs = row["Revs"] ?? ""
                r.tyd = row["Tyd"] ?? ""
                r.pomp = row["Pomp"] ?? ""
                r.druk = row["Druk"] ?? ""
                r.aantalSputkoppe = row["Aantal Sputkoppe"] ?? ""
                r.tipeSputkop = row["Tipe Sputkop"] ?? ""
                r.lewering = row["Lewering (L/ha)"] ?? ""
                r.water = row["Water"] ?? ""
                rows.append(r)
            }
            return (metadata, rows)
        } else if url.pathExtension.lowercased() == "xlsx" {
            guard let file = XLSXFile(filepath: url.path) else { throw ImportError.invalidData }
            guard let path = try file.parseWorksheetPaths().first,
                  let sheet = try file.parseWorksheet(at: path) else { throw ImportError.invalidData }
            var rows: [CalibrationRow] = []
            var metadata = CalibrationMetadata()
            var readingRows = false
            for (index, row) in (sheet.data?.rows ?? []).enumerated() {
                if index < 5 {
                    // metadata rows
                    let val = row.cells.count > 1 ? row.cells[1].stringValue ?? "" : ""
                    switch index {
                    case 0: metadata.producer = val
                    case 1: metadata.farm = val
                    case 2: if let d = ISO8601DateFormatter().date(from: val) { metadata.selectedDate = d }
                    case 3: metadata.agentName = val
                    case 4: metadata.crop = val
                    default: break
                    }
                } else {
                    if !readingRows { readingRows = true; continue } // skip header
                    var r = CalibrationRow()
                    let c = row.cells
                    if c.count >= 10 {
                        r.trekker = c[0].stringValue ?? ""
                        r.rat = c[1].stringValue ?? ""
                        r.revs = c[2].stringValue ?? ""
                        r.tyd = c[3].stringValue ?? ""
                        r.pomp = c[4].stringValue ?? ""
                        r.druk = c[5].stringValue ?? ""
                        r.aantalSputkoppe = c[6].stringValue ?? ""
                        r.tipeSputkop = c[7].stringValue ?? ""
                        r.lewering = c[8].stringValue ?? ""
                        r.water = c[9].stringValue ?? ""
                    }
                    rows.append(r)
                }
            }
            return (metadata, rows)
        }
        throw ImportError.unsupportedFormat
    }

    static func parseRecommendation(url: URL) throws -> (RecommendationMetadata, [RecommendationRow]) {
        if url.pathExtension.lowercased() == "csv" {
            let csv = try CSV(url: url)
            var metadata = RecommendationMetadata()
            var rows: [RecommendationRow] = []
            if let first = csv.namedRows.first {
                metadata.farm = first["Plaas"] ?? ""
                metadata.agentName = first["Agent"] ?? ""
            }
            for row in csv.namedRows.dropFirst() {
                var r = RecommendationRow()
                r.gewas = row["Gewas"] ?? ""
                r.teiken = row["Teiken"] ?? ""
                r.produk = row["Produk"] ?? ""
                r.aktief = row["Aktief"] ?? ""
                r.dosis100LT = row["Dosis/100 LT"] ?? ""
                r.dosisTenK = row["Dosis/Ten K"] ?? ""
                r.ohp = row["OHP"] ?? ""
                r.opmerkings = row["Opmerkings"] ?? ""
                rows.append(r)
            }
            return (metadata, rows)
        } else if url.pathExtension.lowercased() == "xlsx" {
            guard let file = XLSXFile(filepath: url.path) else { throw ImportError.invalidData }
            guard let path = try file.parseWorksheetPaths().first,
                  let sheet = try file.parseWorksheet(at: path) else { throw ImportError.invalidData }
            var rows: [RecommendationRow] = []
            var metadata = RecommendationMetadata()
            var readingRows = false
            for (index, row) in (sheet.data?.rows ?? []).enumerated() {
                if index < 3 {
                    let val = row.cells.count > 1 ? row.cells[1].stringValue ?? "" : ""
                    switch index {
                    case 0: metadata.farm = val
                    case 1: metadata.agentName = val
                    case 2: if let d = ISO8601DateFormatter().date(from: val) { metadata.selectedDate = d }
                    default: break
                    }
                } else {
                    if !readingRows { readingRows = true; continue }
                    var r = RecommendationRow()
                    let c = row.cells
                    if c.count >= 8 {
                        r.gewas = c[0].stringValue ?? ""
                        r.teiken = c[1].stringValue ?? ""
                        r.produk = c[2].stringValue ?? ""
                        r.aktief = c[3].stringValue ?? ""
                        r.dosis100LT = c[4].stringValue ?? ""
                        r.dosisTenK = c[5].stringValue ?? ""
                        r.ohp = c[6].stringValue ?? ""
                        r.opmerkings = c[7].stringValue ?? ""
                    }
                    rows.append(r)
                }
            }
            return (metadata, rows)
        }
        throw ImportError.unsupportedFormat
    }
}
