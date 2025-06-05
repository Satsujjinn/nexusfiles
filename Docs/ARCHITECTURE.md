# NexusFiles Architecture

This document describes the high level structure of the project. NexusFiles is split into multiple modules to keep the core logic reusable across the iOS app and share extension.

## Modules

- **NexusFiles** – Swift package containing models, view models and utilities that implement the app logic.
- **NexusFilesShareExtension** – Share extension target for importing Excel or CSV files.
- **Tests** – Unit tests for the main module

## Source Layout

```
Sources/
├─ ContentView.swift       – Root container for the iOS interface
├─ Models/                – Codable data structures
├─ ViewModels/            – Observable objects that manage state
├─ Views/                 – SwiftUI views
├─ Utilities/             – Helper extensions and cross‑platform utilities
└─ Localization/          – Translated strings
```

Each feature uses the **Model–View–ViewModel (MVVM)** pattern. Models contain persistent data, view models expose observable state and business logic, and views bind to the view models using SwiftUI.

The directory names mirror the target names declared in `Package.swift` so Swift Package Manager can build the modules without additional configuration.

## Folder Organization

The share extension code lives in `ShareExtension/` and is compiled only on iOS.

This layout keeps the main app logic independent from the platform‑specific code, making it easier to maintain and extend.
