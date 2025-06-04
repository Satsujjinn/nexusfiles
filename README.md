# NexusFiles

NexusFiles is an example SwiftUI 5 application demonstrating how to collect structured data and export it to Microsoft Excel. The app contains three data-entry forms and ships with a stub share extension for importing files.

The interface is presented in English. The Home screen automatically populates with folders useful for agricultural documentation such as "Spray Programs" and "MRL".

## Features

- **Tractor Information** – capture pest and weed management data.
- **Calibration** – record calibration details for machinery.
- **Recommendation** – create chemical recommendation lists.
- **Excel Export** – generate `.xlsx` files using [xlsxwriter.swift](https://github.com/damuellen/xlsxwriter.swift).
- **Share Extension Stub** – placeholder for handling incoming Excel or CSV files.
- **Home File Manager** – organize documents into categories, rename them (with duplicate name protection), and quickly locate folders using search from a green-themed home screen.

## Requirements

- macOS 14 or later
- Xcode 17.3
- iOS 17 SDK

## Getting Started

1. Clone this repository.

To run the unit tests in Xcode select **Product ▸ Test** or run `swift test` from
the command line (requires the dependencies above).

The app presents three tabs—Tractor Information, Calibration, and Recommendation—where you can enter data. The toolbar allows you to save the data as an Excel file or share it using the system share sheet.

### Running on Linux



The exported Excel files are saved to the app's documents directory. Each file name includes an ISO‑8601 timestamp for easy organization. Files can be shared directly from the app using the standard iOS share sheet.

### Persistent categories

Categories created on the Home screen are saved as JSON in the app's documents directory. They are automatically sorted alphabetically whenever they're modified.

### iCloud Sync

If iCloud is available, NexusFiles copies saved categories and form drafts to your iCloud container so data is shared across your devices. Ensure you are logged into iCloud before running the app.

## Contributing

Contributions are welcome. Please open issues or pull requests on GitHub. All code is expected to follow Swift style conventions and include clear commit messages.

## License

This project is licensed under the [Apache 2.0 License](LICENSE).
