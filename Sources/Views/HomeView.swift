import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @State private var showingAdd = false
    @State private var newName = ""
    @State private var newIcon = "folder"
    @State private var searchText = ""
    @State private var editName = ""
    @State private var editIcon = "folder"
    @State private var editingCategory: Category?
    @State private var showEdit = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(vm.categories.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { category in
                        NavigationLink(destination: CategoryView(category: category, baseURL: vm.folderURL(for: category.id))) {
                            Label(category.name, systemImage: category.icon)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                        }
                        .contextMenu {
                            Button("Rename") {
                                editingCategory = category
                                editName = category.name
                                editIcon = category.icon
                                showEdit = true
                            }
                        }
                    }
                    .onDelete(perform: vm.deleteCategory)
                }
                .padding()
            }
            .background(Color.green.opacity(0.1))
            .navigationTitle("NexusFiles")
            .searchable(text: $searchText, prompt: "Search Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink("Excel Tables") {
                        ContentView()
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                NavigationStack {
                    Form {
                        TextField("Name", text: $newName)
                        TextField("Icon", text: $newIcon)
                    }
                    .navigationTitle("New Category")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add") {
                                vm.addCategory(name: newName, icon: newIcon)
                                newName = ""
                                newIcon = "folder"
                                showingAdd = false
                            }
                            .disabled(newName.isEmpty)
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingAdd = false }
                        }
                    }
                }
            }
            .sheet(isPresented: $showEdit) {
                NavigationStack {
                    Form {
                        TextField("Name", text: $editName)
                        TextField("Icon", text: $editIcon)
                    }
                    .navigationTitle("Edit Category")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                if let id = editingCategory?.id {
                                    vm.renameCategory(id: id, name: editName, icon: editIcon)
                                }
                                showEdit = false
                            }
                            .disabled(editName.isEmpty)
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showEdit = false }
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
    }
}
