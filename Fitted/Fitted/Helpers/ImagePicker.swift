//
//  ImagePicker.swift
//  Fitted
//
//  This file allows the user to use the camera to take pictures of clothing items
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode // dismiss th view when done
    var sourceType : UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController() // create the camera picker
        picker.delegate = context.coordinator
        picker.sourceType = sourceType // set the source to the camera
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No Updates Needed
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
        let parent : ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker:UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
            if let image = info[.originalImage] as? UIImage{
                parent.selectedImage = image // pass the selected image to the parent
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss() //Dismiss on cancel
        }
    }
    
}
