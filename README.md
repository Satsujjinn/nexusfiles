# NexusFiles 2025

NexusFiles 2025 showcases a SwiftUI 6 workflow for collecting structured data and exporting it to Microsoft Excel. The app contains three data-entry forms and includes a share extension for importing files. The primary experience is designed for iPhone.

The interface is presented in English. The Home screen automatically populates with folders useful for agricultural documentation such as "Spray Programs" and "MRL".

## Features

- **Tractor Information** – capture pest and weed management data.
- **Calibration** – record calibration details for machinery.
- **Recommendation** – create chemical recommendation lists.
- **Excel Export** – generate `.csv` files that can be opened in spreadsheet apps.
- **In-App Import** – load existing Excel or CSV files into the data entry forms for editing.
- **Share Extension Stub** – placeholder for handling incoming Excel or CSV files.
- **Home File Manager** – organize documents into categories, rename them (with duplicate name protection), and quickly locate folders using search from a green-themed home screen.
- **Category Counts** – each folder on the Home screen now shows how many documents it contains.

## Architecture

The project follows a modular MVVM design. Core models, view models and helper utilities live in the `Sources` directory and are shared by the iOS app and share extension. Each feature is split into `Models`, `ViewModels` and `Views` to keep UI and data logic separate.

See [Docs/ARCHITECTURE.md](Docs/ARCHITECTURE.md) for a detailed overview of the folder layout and Swift Package targets.

## Requirements

- macOS 15 or later
- Xcode 17.3
- iOS 19 SDK

## Getting Started

1. Clone this repository.
2. Open `Package.swift` in Xcode 17.3 or later or build from the command line with `swift build`.
3. To run the unit tests in Xcode select **Product ▸ Test** or run `swift test` from the command line.


The app presents three tabs—Tractor Information, Calibration, and Recommendation—where you can enter data. The toolbar allows you to save the data as an Excel file or share it using the system share sheet.

### Running on Linux

NexusFiles depends on SwiftUI for its graphical interface and therefore cannot run on Linux. The exported files are saved in the app's documents directory on iOS and can be shared using the standard share sheet.

### Persistent categories

Categories created on the Home screen are saved as JSON in the app's documents directory. They are automatically sorted alphabetically whenever they're modified.

### iCloud Sync

If iCloud is available, NexusFiles 2025 copies saved categories and form drafts to your iCloud container so data is shared across your devices. Ensure you are logged into iCloud before running the app.


## Contributing

Contributions are welcome. Please open issues or pull requests on GitHub. All code is expected to follow Swift style conventions and include clear commit messages.

## License

This project is licensed under the [Apache 2.0 License](LICENSE).
