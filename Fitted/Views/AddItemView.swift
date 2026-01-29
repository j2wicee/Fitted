//
//  AddItemView.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/28/26.
//
import SwiftUI
struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var wardrobe: Wardrobe
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var useCamera = false
    
    @State private var name = ""
    @State private var type = ""
    @State private var color: Color = .blue
    @State private var size = ""
    
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Photo")){
                    HStack{
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .cornerRadius(8)
                        }else{
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 100)
                                .overlay(Text("No Image"))
                        }
                    }
                    HStack{
                        Button("Pick Photo"){
                            useCamera = false
                            showImagePicker = true
                        }
                        Spacer()
                        Button("Take Photo"){
                            useCamera = true
                            showImagePicker = true
                        }
                    }
                }
                Section(header: Text("Clothing Details")){
                    TextField("Name", text: $name)
                    TextField("Type", text: $type)
                    ColorPicker("Color", selection: $color)
                    TextField("Size (optional)", text:$size)
                }
            }
            .navigationTitle("Add Item")
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        let newItem = ClothingItem(name: name, type: type, color: color, size: size, image: selectedImage)
                        wardrobe.addItem(newItem)
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                }
                ToolbarItem(placement:.cancellationAction){
                    Button("Cancel"){
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }.sheet(isPresented: $showImagePicker) {
            ImagePicker(
                selectedImage: $selectedImage,
                sourceType: useCamera ? .camera : .photoLibrary
            )
        }
        }
        
    }

