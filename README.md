# NexusFiles 2025

NexusFiles 2025 showcases a SwiftUI 6 workflow for collecting structured data and exporting it to Microsoft Excel. The app contains three data-entry forms and includes a share extension for importing files. While a minimal macOS build and CLI are provided, the primary experience is designed for iPhone.

The interface is presented in English. The Home screen automatically populates with folders useful for agricultural documentation such as "Spray Programs" and "MRL".

## Features

- **Tractor Information** – capture pest and weed management data.
- **Calibration** – record calibration details for machinery.
- **Recommendation** – create chemical recommendation lists.
- **Excel Export** – generate `.xlsx` files using [xlsxwriter.swift](https://github.com/damuellen/xlsxwriter.swift).
- **In-App Import** – load existing Excel or CSV files into the data entry forms for editing.
- **Share Extension Stub** – placeholder for handling incoming Excel or CSV files.
- **Home File Manager** – organize documents into categories, rename them (with duplicate name protection), and quickly locate folders using search from a green-themed home screen.
- **Category Counts** – each folder on the Home screen now shows how many documents it contains.

## Architecture

The project follows a modular MVVM design. Core models, view models and helper utilities live in the `Sources` directory and are shared by the macOS app, iOS app and command line tool. Each feature is split into `Models`, `ViewModels` and `Views` to keep UI and data logic separate. Additional entry points such as the CLI and share extension reside at the repository root.

See [Docs/ARCHITECTURE.md](Docs/ARCHITECTURE.md) for a detailed overview of the folder layout and Swift Package targets.

## Requirements

- macOS 15 or later
- Xcode 17.3
- iOS 19 SDK

## Getting Started

1. Clone this repository.
2. From the project root run `pod install` to install the CocoaPods dependencies and generate `NexusFiles.xcworkspace`.
3. Open `NexusFiles.xcworkspace` in Xcode 17.3 or later.
4. Select the **NexusFilesMac** scheme and build or run the app. You can also execute `swift run NexusFilesMac` from the command line.
5. To run the unit tests in Xcode select **Product ▸ Test** or run `swift test` from the command line (requires the dependencies above).


The app presents three tabs—Tractor Information, Calibration, and Recommendation—where you can enter data. The toolbar allows you to save the data as an Excel file or share it using the system share sheet.

### Install using CocoaPods for Xcode

For iOS and macOS projects in Xcode you can install `libxlsxwriter` using CocoaPods.

Add the following entry to your **Podfile**:

```ruby
pod 'libxlsxwriter', '~> 0.9'
```

If you are using Swift, you can now add an import:

```swift
import xlsxwriter
```

And call its C functions like this:

```swift
let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
let fileURL = documentDirectory.appendingPathComponent("hello_world.xlsx")

let workbook = workbook_new((fileURL.absoluteString.dropFirst(6) as NSString).fileSystemRepresentation)
let worksheet = workbook_add_worksheet(workbook, nil)
worksheet_write_string(worksheet, 0, 0, "Hello", nil)
worksheet_write_number(worksheet, 1, 0, 123, nil)
workbook_close(workbook)
```

For a sample Xcode project that uses the `libxlsxwriter` cocoapod for iOS and macOS with Objective‑C and Swift see **libxlsxwriter Cocoa Examples** or **LibXlsxWriterSwiftSample**.

### Installation on macOS with Homebrew

On macOS you can install `libxlsxwriter` using [Homebrew](https://brew.sh):

```bash
brew install libxlsxwriter
```

After installation, compile and run a program using the library with:

```bash
cc myexcel.c -o myexcel -I/usr/local/include -L/usr/local/lib -lxlsxwriter
./myexcel
```

### Running on Linux

NexusFiles depends on SwiftUI for its graphical interface, so the macOS app is
not available on Linux. The command line utilities can still be built and run
using Swift Package Manager. After installing Swift, build the package and run
the desired subcommand:

```bash
swift build
swift run nexusfiles export-calibration meta.json rows.json
```

Replace the subcommand with `export-tractor-info` or
`export-recommendation` to generate the other Excel file types.

The exported Excel files are saved to the app's documents directory. Each file
name includes an ISO‑8601 timestamp for easy organization. Files can be shared
directly from the app using the standard iOS share sheet.

### Persistent categories

Categories created on the Home screen are saved as JSON in the app's documents directory. They are automatically sorted alphabetically whenever they're modified.

### iCloud Sync

If iCloud is available, NexusFiles 2025 copies saved categories and form drafts to your iCloud container so data is shared across your devices. Ensure you are logged into iCloud before running the app.

## Command Line Usage

This package also includes a CLI tool built with [swift-argument-parser](https://github.com/apple/swift-argument-parser). It lets you generate Excel files from JSON data without opening the app.

Build and run the CLI:

```bash
swift run nexusfiles export-calibration meta.json rows.json
```

Replace `export-calibration` with `export-tractor-info` or `export-recommendation` for the other form types. Each command prints the path to the generated Excel file.

To convert an existing Excel file to a PDF you can run:

```bash
swift run nexusfiles convert-pdf MySheet.xlsx
```

The command copies `MySheet.xlsx` to a new `.pdf` file at the same location.

## Contributing

Contributions are welcome. Please open issues or pull requests on GitHub. All code is expected to follow Swift style conventions and include clear commit messages.

## License

This project is licensed under the [Apache 2.0 License](LICENSE).
