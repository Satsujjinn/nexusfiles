import UIKit
import Social
import NexusFiles

class ShareViewController: UIViewController {
    private let homeVM = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        handleIncomingFile()
    }

    private func handleIncomingFile() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let provider = item.attachments?.first else {
            return
        }
        if provider.hasItemConformingToTypeIdentifier("public.data") {
            provider.loadInPlaceFileRepresentation(forTypeIdentifier: "public.data") { url, _, _ in
                if let url {
                    DispatchQueue.main.async { self.presentOptions(for: url) }
                }
            }
        }
    }

    private func presentOptions(for url: URL) {
        let alert = UIAlertController(title: "Import File", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Tractor Info", style: .default) { _ in self.importTractor(url) })
        alert.addAction(UIAlertAction(title: "Calibration", style: .default) { _ in self.importCalibration(url) })
        alert.addAction(UIAlertAction(title: "Recommendation", style: .default) { _ in self.importRecommendation(url) })
        for cat in homeVM.categories {
            alert.addAction(UIAlertAction(title: cat.name, style: .default) { _ in self.save(url, to: cat) })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in self.extensionContext?.completeRequest(returningItems: nil) })
        present(alert, animated: true)
    }

    private func save(_ url: URL, to category: Category) {
        let dest = uniqueURL(for: url, in: category)
        do {
            try FileManager.default.copyItem(at: url, to: dest)
            Task { await homeVM.loadCategories() }
            extensionContext?.completeRequest(returningItems: nil)
        } catch {
            showError()
        }
    }

    private func uniqueURL(for url: URL, in category: Category) -> URL {
        var dest = homeVM.folderURL(for: category.id).appendingPathComponent(url.lastPathComponent)
        var i = 1
        while FileManager.default.fileExists(atPath: dest.path) {
            let name = url.deletingPathExtension().lastPathComponent + "-\(i)"
            dest = homeVM.folderURL(for: category.id).appendingPathComponent(name).appendingPathExtension(url.pathExtension)
            i += 1
        }
        return dest
    }

    private func importTractor(_ url: URL) {
        do {
            let (pests, weeds) = try DataImporter.parseTractorInfo(url: url)
            let vm = TractorInfoViewModel()
            vm.pests.append(contentsOf: pests)
            vm.weeds.append(contentsOf: weeds)
            vm.saveDraft()
            extensionContext?.completeRequest(returningItems: nil)
        } catch { showError() }
    }

    private func importCalibration(_ url: URL) {
        do {
            let (meta, rows) = try DataImporter.parseCalibration(url: url)
            let vm = CalibrationViewModel()
            vm.metadata = meta
            vm.rows.append(contentsOf: rows)
            vm.saveDraft()
            extensionContext?.completeRequest(returningItems: nil)
        } catch { showError() }
    }

    private func importRecommendation(_ url: URL) {
        do {
            let (meta, rows) = try DataImporter.parseRecommendation(url: url)
            let vm = RecommendationViewModel()
            vm.metadata = meta
            vm.rows.append(contentsOf: rows)
            vm.saveDraft()
            extensionContext?.completeRequest(returningItems: nil)
        } catch { showError() }
    }

    private func showError() {
        let err = UIAlertController(title: "Error", message: "Import failed", preferredStyle: .alert)
        err.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.extensionContext?.completeRequest(returningItems: nil)
        })
        present(err, animated: true)
    }
}
