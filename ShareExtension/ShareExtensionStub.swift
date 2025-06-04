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
                    DispatchQueue.main.async { self.presentSave(for: url) }
                }
            }
        }
    }

    private func presentSave(for url: URL) {
        let alert = UIAlertController(title: "Import File", message: "Choose Category", preferredStyle: .actionSheet)
        for cat in homeVM.categories {
            alert.addAction(UIAlertAction(title: cat.name, style: .default) { _ in
                self.save(url, to: cat)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.extensionContext?.completeRequest(returningItems: nil)
        })
        present(alert, animated: true)
    }

    private func save(_ url: URL, to category: Category) {
        let dest = homeVM.folderURL(for: category.id).appendingPathComponent(url.lastPathComponent)
        do {
            try FileManager.default.copyItem(at: url, to: dest)
            homeVM.loadCategories()
            extensionContext?.completeRequest(returningItems: nil)
        } catch {
            let err = UIAlertController(title: "Error", message: "Import failed", preferredStyle: .alert)
            err.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.extensionContext?.completeRequest(returningItems: nil)
            })
            present(err, animated: true)
        }
    }
}

