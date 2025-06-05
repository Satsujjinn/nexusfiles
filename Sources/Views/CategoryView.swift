import SwiftUI

struct CategoryView: View {
    let category: Category
    let baseURL: URL
    @State private var items: [URL] = []
    @State private var showingImport = false
    @State private var importURL: URL?
    @State private var shareURL: URL?
    @State private var previewURL: URL?
    @State private var editURL: URL?
    @State private var isSaving = false

    var body: some View {
        List {
            ForEach(items, id: \._self) { url in
                HStack {
                    Image(systemName: url.hasDirectoryPath ? "folder" : "doc")
                    Text(url.lastPathComponent)
                        .onTapGesture {
                            if !url.hasDirectoryPath {
                                if url.pathExtension.lowercased() == "xlsx" {
                                    editURL = url
                                } else if let pdf = try? PDFExporter.convertExcelToPDF(url: url) {
                                    previewURL = pdf
                                } else {
                                    previewURL = url
                                }
                            }
                        }
                    Spacer()
                    if !url.hasDirectoryPath {
                        Button(action: { share(url) }) { Image(systemName: "square.and.arrow.up") }
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .applyAppTheme()
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingImport = true }) { Image(systemName: "plus") }
            }
        }
        .task { await load() }
        .fileImporter(isPresented: $showingImport, allowedContentTypes: [.data], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                if let first = urls.first { importURL = first; Task { await saveImported() } }
            case .failure(let error):
                print("Import error: \(error)")
            }
        }
        .sheet(item: $shareURL) { url in ActivityView(activityItems: [url]) }
        .sheet(item: $previewURL) { url in QuickLookPreview(url: url) }
        .sheet(item: $editURL) { url in SpreadsheetEditorView(url: url) }
        .overlay(Group { if isSaving { ProgressView().progressViewStyle(.circular) } })
    }

    private func load() async {
        do {
            let urls: [URL] = try await Task.detached { try FileManager.default.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil) }.value
            items = urls
        } catch {
            print("Load error: \(error)")
        }
    }

    private func delete(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let url = items[index]
                try? FileManager.default.removeItem(at: url)
            }
            await load()
        }
    }

    private func share(_ url: URL) {
        if url.pathExtension.lowercased() == "xlsx" {
            if let pdfURL = try? PDFExporter.convertExcelToPDF(url: url) {
                shareURL = pdfURL
                return
            }
        }
        shareURL = url
    }

    private func uniqueURL(for url: URL) -> URL {
        var dest = baseURL.appendingPathComponent(url.lastPathComponent)
        var counter = 1
        while FileManager.default.fileExists(atPath: dest.path) {
            let name = url.deletingPathExtension().lastPathComponent + "-\(counter)"
            dest = baseURL.appendingPathComponent(name).appendingPathExtension(url.pathExtension)
            counter += 1
        }
        return dest
    }

    private func saveImported() async {
        guard let importURL else { return }
        let dest = uniqueURL(for: importURL)
        do {
            isSaving = true
            try await Task.detached { try FileManager.default.copyItem(at: importURL, to: dest) }.value
            isSaving = false
        } catch {
            print("Copy error: \(error)")
            isSaving = false
        }
        await load()
    }
}
