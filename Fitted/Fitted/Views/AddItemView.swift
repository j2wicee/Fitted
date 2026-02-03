//
//  AddItemView.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/28/26.
//

//TODO: NEED TO RESOLVE THE TAKING PHOTO ERRORS, PHOTOS NOT SHOWING UP AFTER TAKING PHOTO
import SwiftUI
import PhotosUI
struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var wardrobe: Wardrobe
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    
    @State private var name = ""
    @State private var type : ClothingType = .shirt
    @State private var color: Color = .blue
    @State private var size : ClothingSize = .m
    
    
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
                        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()){
                            Text("Select Photo")
                        }
                        .buttonStyle(.borderless)
                        .onChange(of: selectedItem){
                            newItem in
                            
                            if let newItem = newItem{
                                Task{
                                    if let data = try? await newItem.loadTransferable(type: Data.self),let image = UIImage(data:data){
                                        selectedImage = image
                                        
                                    }
                                }
                            }
                        }
                        Spacer()
                        Button("Take Photo"){
                            showImagePicker = true
                        }
                        .buttonStyle(.borderless)
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(
                                selectedImage: $selectedImage,
                                sourceType: .camera
                            )
                        }
                    }
                }
                Section(header: Text("Clothing Details")){
                    TextField("Name", text: $name)
                    Picker("Type", selection: $type){
                        ForEach(ClothingType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                        ColorPicker("Color", selection: $color)
                        Picker("Size", selection: $size) {
                            ForEach(ClothingSize.allCases, id: \.self) { size in
                                Text(size.rawValue).tag(size)
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
                }
            }
            
        }
        
    }
}
