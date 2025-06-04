import UIKit
import Social

class ShareViewController: UIViewController {
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
        let picker = UIDocumentPickerViewController(forExporting: [url])
        picker.shouldShowFileExtensions = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ShareViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        extensionContext?.completeRequest(returningItems: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        extensionContext?.completeRequest(returningItems: nil)
    }
}
