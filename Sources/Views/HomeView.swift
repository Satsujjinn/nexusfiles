import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @State private var showingAdd = false
    @State private var newName = ""
    @State private var newIcon = "folder"
    @State private var newColor = "blue"
    @State private var searchText = ""
    @State private var editName = ""
    @State private var editIcon = "folder"
    @State private var editColor = "blue"
    @State private var editingCategory: Category?
    @State private var showEdit = false
    private let colorOptions: [(name: String, color: Color)] = [
        ("blue", .blue),
        ("green", .green),
        ("red", .red),
        ("orange", .orange),
        ("purple", .purple),
        ("pink", .pink),
        ("gray", .gray),
        ("yellow", .yellow)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(vm.categories.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { category in
                        NavigationLink(destination: CategoryView(category: category, baseURL: vm.folderURL(for: category.id))) {
                            Label("\(category.name) (\(vm.itemCount(for: category)))", systemImage: category.icon)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(category.color))
                                .cornerRadius(8)
                                .shadow(radius: 1)
                        }
                        .contextMenu {
                            Button("Rename".localized) {
                                editingCategory = category
                                editName = category.name
                                editIcon = category.icon
                                editColor = category.color
                                showEdit = true
                            }
                        }
                    }
                    .onMove(perform: vm.moveCategory)
                    .onDelete(perform: vm.deleteCategory)
                }
                .padding()
            }
            .background(Color.white)
            .navigationTitle("NexusFiles 2025".localized)
            .searchable(text: $searchText, prompt: "Search Categories".localized) {
                if searchText.isEmpty {
                    ForEach(vm.categories) { cat in
                        Text(cat.name).searchCompletion(cat.name)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink("Excel Tables".localized) {
                        ContentView()
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                NavigationStack {
                    Form {
                        TextField("Name".localized, text: $newName)
                        TextField("Icon".localized, text: $newIcon)
                        Picker("Color".localized, selection: $newColor) {
                            ForEach(colorOptions, id: \.name) { option in
                                HStack {
                                    Circle()
                                        .fill(option.color)
                                        .frame(width: 16, height: 16)
                                    Text(option.name.capitalized)
                                }
                                .tag(option.name)
                            }
                        }
                    }
                    .navigationTitle("New Category".localized)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add".localized) {
                                vm.addCategory(name: newName, icon: newIcon, color: newColor)
                                newName = ""
                                newIcon = "folder"
                                newColor = "blue"
                                showingAdd = false
                            }
                            .disabled(newName.isEmpty)
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel".localized) { showingAdd = false }
                        }
                    }
                }
            }
            .sheet(isPresented: $showEdit) {
                NavigationStack {
                    Form {
                        TextField("Name".localized, text: $editName)
                        TextField("Icon".localized, text: $editIcon)
                        Picker("Color".localized, selection: $editColor) {
                            ForEach(colorOptions, id: \.name) { option in
                                HStack {
                                    Circle()
                                        .fill(option.color)
                                        .frame(width: 16, height: 16)
                                    Text(option.name.capitalized)
                                }
                                .tag(option.name)
                            }
                        }
                    }
                    .navigationTitle("Edit Category".localized)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save".localized) {
                                if let id = editingCategory?.id {
                                    vm.renameCategory(id: id, name: editName, icon: editIcon, color: editColor)
                                }
                                showEdit = false
                            }
                            .disabled(editName.isEmpty)
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel".localized) { showEdit = false }
                        }
                    }
                }
            }
            .tint(.green)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .applyAppTheme()
    }
}
