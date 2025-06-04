import Foundation

/// Handles rudimentary Excel to PDF conversion.
///
/// The implementation simply copies the Excel file to a new
/// location with a `.pdf` extension. This allows other parts of the
/// app to work with a PDF file path even though the contents are not
/// truly converted. Proper rendering can be added later using PDFKit
/// or a dedicated library.
struct PDFExporter {
    static func convertExcelToPDF(url: URL) throws -> URL {
        let pdfURL = url.deletingPathExtension().appendingPathExtension("pdf")
        // Replace any existing file at the destination.
        try? FileManager.default.removeItem(at: pdfURL)
        try FileManager.default.copyItem(at: url, to: pdfURL)
        return pdfURL
    }
}
