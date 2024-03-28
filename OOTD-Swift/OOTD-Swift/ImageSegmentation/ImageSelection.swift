//
//  ImageSelection.swift
//  OOTD-Swift
//
//  Created by Rishabh Pandey on 2/26/24.
//

import SwiftUI
import PhotosUI
import Vision

struct ImageSelectionView: View {
    @State private var shouldPresentImagePicker = false
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    
    var completionHandler: ((UIImage?) -> Void)?
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            Button("Select Image") {
                checkPhotoLibraryAuthorizationStatus()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            PhotoPicker(image: $image, onDismiss: processSelectedImage)
        }
    }
    
    private func checkPhotoLibraryAuthorizationStatus() {
        let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch readWriteStatus {
        case .notDetermined, .restricted, .denied:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        self.showingImagePicker = true
                    } else {
                        // Handle cases where permission is denied or restricted
                        print("Photo Library Access Denied or Restricted")
                    }
                }
            }
        case .authorized, .limited:
            showingImagePicker = true
        @unknown default:
            fatalError("Unknown PHAuthorizationStatus returned")
        }
    }
    
    private func processSelectedImage() {
        guard let selectedImage = image else { return }
        if #available(iOS 17.0, *) {
            processImage(selectedImage) { maskedImage in
                // Update your UI or model with the processed image here
                if let maskedImage = maskedImage {
                     print("Masked image processed successfully")
                 } else {
                     print("Failed to process masked image")
                 }
            }
        }
    }
    
    @available(iOS 17.0, *)
    private func processImage(_ image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        // Initialize a request for subject lifting
       let request = VNGenerateForegroundInstanceMaskRequest(completionHandler: { [self] request, error in
           guard let results = request.results as? [VNPixelBufferObservation],
                 let result = results.first else {
               completion(nil)
               return
           }
           
           // Generate a masked image from the result
           let maskedImage = self.generateMaskedImage(from: result, sourceImage: cgImage)
           completion(maskedImage)
       })
       
       // Execute the request with a request handler
       let handler = VNImageRequestHandler(cgImage: cgImage)
       DispatchQueue.global(qos: .userInitiated).async {
           do {
               try handler.perform([request])
           } catch {
               print("Failed to perform Vision request:", error)
               completion(nil)
           }
       }
    }
    
    func generateMaskedImage(from observation: VNPixelBufferObservation, sourceImage: CGImage) -> UIImage? {
          // The observation's pixel buffer needs to be converted to a CIImage or UIImage.
          // This example does not directly implement this conversion, as it depends on your specific needs.
          // You might use Core Image (CIImage) to apply the mask to the sourceImage.
          let maskCIImage = CIImage(cvPixelBuffer: observation.pixelBuffer)
          
          // Create a CIImage from the sourceImage for masking
          let sourceCIImage = CIImage(cgImage: sourceImage)
          
          // Use a Core Image filter to apply the mask
          let filter = CIFilter(name: "CIBlendWithMask", parameters: [
              "inputImage": sourceCIImage,
              "inputMaskImage": maskCIImage,
              "inputBackgroundImage": CIImage.empty()
          ])
          
          // Convert the filtered CIImage back to UIImage
          if let outputCIImage = filter?.outputImage,
             let outputCGImage = CIContext().createCGImage(outputCIImage, from: outputCIImage.extent) {
              let maskedImage = UIImage(cgImage: outputCGImage)
              
              DispatchQueue.main.async {
                  self.completionHandler?(maskedImage)
              }
              
              return maskedImage
          }
          
          DispatchQueue.main.async {
              self.completionHandler?(nil)
          }
          
          return nil
      }

}

struct PhotoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var onDismiss: () -> Void
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true) {
                self.parent.onDismiss()
            }
            
            guard let result = results.first else { return }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.image = image
                    }
                }
            }
        }
    }
}


