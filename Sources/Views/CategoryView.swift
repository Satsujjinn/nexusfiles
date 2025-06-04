import SwiftUI

struct CategoryView: View {
    let category: Category
    let baseURL: URL
    @State private var items: [URL] = []
    @State private var showingImport = false
    @State private var importURL: URL?
    @State private var shareURL: URL?
    @State private var isSaving = false

    var body: some View {
        List {
            ForEach(items, id: \.self) { url in
                HStack {
                    Image(systemName: url.hasDirectoryPath ? "folder" : "doc")
                    Text(url.lastPathComponent)
                    Spacer()
                    if !url.hasDirectoryPath {
                        Button(action: { share(url) }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingImport = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear(perform: load)
        .fileImporter(isPresented: $showingImport, allowedContentTypes: [.data], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                if let first = urls.first { importURL = first; saveImported() }
            case .failure(let error):
                print("Import error: \(error)")
            }
        }
        .sheet(item: $shareURL) { url in
            ActivityView(activityItems: [url])
        }
        .overlay(Group { if isSaving { ProgressView().progressViewStyle(.circular) } })
    }

    private func load() {
        do {
            items = try FileManager.default.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil)
        } catch {
            print("Load error: \(error)")
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let url = items[index]
            try? FileManager.default.removeItem(at: url)
        }
        load()
    }

    private func share(_ url: URL) {
        shareURL = url
    }

    private func saveImported() {
        guard let importURL else { return }
        let dest = baseURL.appendingPathComponent(importURL.lastPathComponent)
        do {
            isSaving = true
            try FileManager.default.copyItem(at: importURL, to: dest)
            isSaving = false
        } catch {
            print("Copy error: \(error)")
            isSaving = false
        }
        load()
    }
}
