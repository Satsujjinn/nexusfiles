import SwiftUI

struct UploadView: View {
    let fileURL: URL
    @Environment(\.dismiss) private var dismiss
    @StateObject private var homeVM = HomeViewModel()
    @State private var selectedCategory: Category?
    @State private var progress: Double = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Save \(fileURL.lastPathComponent)").font(.headline)
                Picker("Destination".localized, selection: $selectedCategory) {
                    ForEach(homeVM.categories) { cat in
                        Text(cat.name).tag(Optional(cat))
                    }
                }
                .pickerStyle(.wheel)
                if progress > 0 && progress < 1 {
                    ProgressView(value: progress)
                }
                Button("Save".localized) { save() }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedCategory == nil)
            }
            .padding()
            .navigationTitle("Upload".localized)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel".localized) { dismiss() } } }
            .applyAppTheme()
        }
    }

    private func save() {
        guard let cat = selectedCategory else { return }
        let dest = homeVM.folderURL(for: cat.id).appendingPathComponent(fileURL.lastPathComponent)
        do {
            let data = try Data(contentsOf: fileURL)
            try data.write(to: dest)
            progress = 1
            dismiss()
        } catch {
            print("Save error: \(error)")
        }
    }
}
