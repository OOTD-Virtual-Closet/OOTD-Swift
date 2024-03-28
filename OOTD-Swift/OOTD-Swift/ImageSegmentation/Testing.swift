//
//  Testing.swift
//  OOTD-Swift
//
//  Created by Rishabh Pandey on 2/26/24.
//

import SwiftUI
import Photos

import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController // This specifies the type of view controller we're representing
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator // Set the delegate to the coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update the UI when SwiftUI state changes, if necessary
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct Testing: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var showingLimitedAccessAlert = false

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
            }
            Button("Select Image") {
                checkPhotoLibraryAccess()
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePickerView(selectedImage: $selectedImage)
                .onAppear {
                    isImagePickerPresented = true
                }
        }
    }
    
    func checkPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined, .restricted, .denied:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self.isImagePickerPresented = true
                    } else {
                        print("Photo Libarary Access Denied...")
                        return
                    }
                }
            }
        case .authorized, .limited:
            isImagePickerPresented = true
        @unknown default:
            fatalError("Unknown PHAuthorizationStatus returned")
        }
    }
}

struct Testing_Previews: PreviewProvider {
    static var previews: some View {
        Testing()
    }
}
