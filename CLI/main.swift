import ArgumentParser
import NexusFiles

@main
struct NexusFilesCLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Command line tools for NexusFiles",
        subcommands: [ExportTractorInfo.self, ExportCalibration.self, ExportRecommendation.self])
}

struct ExportTractorInfo: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Export tractor info Excel file from JSON data")

    @Argument(help: "Path to input JSON file")
    var input: String

    func run() throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: input))
        let decoder = JSONDecoder()
        let rows = try decoder.decode([PestRow].self, from: data)
        let url = try ExcelExporter.exportTractorInfo(pestRows: rows, weedRows: [])
        print("Excel exported to \(url.path)")
    }
}

struct ExportCalibration: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Export calibration Excel file from JSON data")

    @Argument(help: "Path to metadata JSON file")
    var meta: String

    @Argument(help: "Path to rows JSON file")
    var rowsFile: String

    func run() throws {
        let decoder = JSONDecoder()
        let metaData = try decoder.decode(CalibrationMetadata.self, from: Data(contentsOf: URL(fileURLWithPath: meta)))
        let rows = try decoder.decode([CalibrationRow].self, from: Data(contentsOf: URL(fileURLWithPath: rowsFile)))
        let url = try ExcelExporter.exportCalibration(metadata: metaData, rows: rows)
        print("Excel exported to \(url.path)")
    }
}

struct ExportRecommendation: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Export recommendation Excel file from JSON data")

    @Argument(help: "Path to metadata JSON file")
    var meta: String

    @Argument(help: "Path to rows JSON file")
    var rowsFile: String

    func run() throws {
        let decoder = JSONDecoder()
        let metaData = try decoder.decode(RecommendationMetadata.self, from: Data(contentsOf: URL(fileURLWithPath: meta)))
        let rows = try decoder.decode([RecommendationRow].self, from: Data(contentsOf: URL(fileURLWithPath: rowsFile)))
        let url = try ExcelExporter.exportRecommendation(metadata: metaData, rows: rows)
        print("Excel exported to \(url.path)")
    }
}
