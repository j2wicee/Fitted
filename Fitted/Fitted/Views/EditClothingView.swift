import SwiftUI
struct EditClothingView: View {
    @Binding var item: ClothingItem
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Name", text: $item.name)

                    Picker("Type", selection: $item.type) {
                        ForEach(ClothingType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }

                    Picker("Size", selection: $item.size) {
                        ForEach(ClothingSize.allCases) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }

                    ColorPicker("Color", selection: $item.color)
                }
            }
            .navigationTitle("Edit Item")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
