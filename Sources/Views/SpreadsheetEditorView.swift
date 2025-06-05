#if canImport(SwiftUI)
import SwiftUI
import CoreXLSX

/// A simple Excel spreadsheet editor for `.xlsx` files.
struct SpreadsheetEditorView: View {
    let url: URL
    @State private var rows: [[String]] = []
    @Environment(\.dismiss) private var dismiss
    @State private var loading = true

    var body: some View {
        NavigationStack {
            Group {
                if loading {
                    ProgressView()
                } else {
                    List {
                        ForEach(rows.indices, id: \.__self) { rowIndex in
                            HStack {
                                ForEach(rows[rowIndex].indices, id: \.__self) { colIndex in
                                    TextField("", text: Binding(
                                        get: { rows[rowIndex][colIndex] },
                                        set: { rows[rowIndex][colIndex] = $0 }
                                    ))
                                    .textFieldStyle(.roundedBorder)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(url.lastPathComponent)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Upload") { Task { await upload() } }
                }
            }
            .task { await load() }
        }
    }

    private func load() async {
        guard url.pathExtension.lowercased() == "xlsx" else { loading = false; return }
        do {
            guard let file = XLSXFile(filepath: url.path) else { return }
            guard let path = try file.parseWorksheetPaths().first,
                  let sheet = try file.parseWorksheet(at: path) else { return }
            var tmp: [[String]] = []
            for row in sheet.data?.rows ?? [] {
                tmp.append(row.cells.map { $0.stringValue ?? "" })
            }
            rows = tmp
        } catch {
            print("Parse error: \(error)")
        }
        loading = false
    }

    /// Upload the edited spreadsheet to a remote server.
    private func upload() async {
        let csv = rows.map { $0.joined(separator: ",") }.joined(separator: "\n")
        guard let data = csv.data(using: .utf8),
              let uploadURL = URL(string: "https://example.com/upload") else { return }
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = multipartBody(boundary: boundary, data: data, fileName: url.lastPathComponent)
        do {
            _ = try await URLSession.shared.data(for: request)
            dismiss()
        } catch {
            print("Upload error: \(error)")
        }
    }

    private func multipartBody(boundary: String, data: Data, fileName: String) -> Data {
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
#endif

