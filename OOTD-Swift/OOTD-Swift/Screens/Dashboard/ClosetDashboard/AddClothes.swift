//
//  AddClothes.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/27/24.
//


import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import PhotosUI
import UIKit

extension UIImage {
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthRatio = rectSize.width / size.width
        let heightRatio = rectSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        return UIGraphicsImageRenderer(size: scaledImageSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
    }
}

struct AddClothes: View {
    @Environment(\.presentationMode) var presentationMode

    private var sizeOptions = ["XS", "S", "M", "L", "XL", "XXL"]
    private var typeOptions = ["Tops", "Bottoms", "Jackets/Hoodies", "Shoes"]
    private var colorOptions = ["Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Indigo", "Violet", "Tomato Red", "Greenish Cob"]
    @State private var isEditing = false
    @State private var isEditing2 = false
    
    @State private var isImagePickerPresented = false
    @State var selectedImage: UIImage?

    @State private var name : String?
    @State private var selectedType : String?
    @State private var selectedSize : String?
    @State private var selectedColor : String?
    @State private var searchText = ""
    
    @State private var searchText2 = ""
    
    @State var color = Color(hex: "9278E0")
    @State var showAlert = false
    @State var alertMessage = "Please fill out all fields"
    
    func getImageForSelectedType() -> UIImage? {
            guard let selectedType = selectedType else {
                return nil
            }
           
            switch selectedType {
            case "Tops":
                let randomVal = Int.random(in: 1...8)
                if randomVal == 1 {
                    let uiImage = UIImage(named: "shirt")
                    return uiImage
                }
                if randomVal == 2 {
                    let uiImage = UIImage(named: "shirt2")
                    return uiImage
                }
                if randomVal == 3 {
                    let uiImage = UIImage(named: "shirt3")
                    return uiImage
                }
                if randomVal == 4 {
                    let uiImage = UIImage(named: "shirt4")
                    return uiImage
                }
                if randomVal == 5 {
                    let uiImage = UIImage(named: "shirt5")
                    return uiImage
                }
                if randomVal == 6 {
                    let uiImage = UIImage(named: "shirt6")
                    return uiImage
                }
                if randomVal == 7 {
                    let uiImage = UIImage(named: "shirt7")
                    return uiImage
                }
                let uiImage = UIImage(named: "shirt8")
                return uiImage
            case "Bottoms":
                let randomVal = Int.random(in: 1...4)
                if randomVal == 1 {
                    let uiImage = UIImage(named: "jeans")
                    return uiImage
                }
                if randomVal == 2 {
                    let uiImage = UIImage(named: "jeans2")
                    return uiImage
                }
                if randomVal == 3 {
                    let uiImage = UIImage(named: "jeans3")
                    return uiImage
                }
                let uiImage = UIImage(named: "jeans4")
                return uiImage
            case "Jackets/Hoodies":
                let randomVal = Int.random(in: 1...5)
                if randomVal == 1 {
                    let uiImage = UIImage(named: "jacket")
                    return uiImage
                }
                if randomVal == 2 {
                    let uiImage = UIImage(named: "hoodie")
                    return uiImage
                }
                if randomVal == 3 {
                    let uiImage = UIImage(named: "hoodie2")
                    return uiImage
                }
                if randomVal == 4 {
                    let uiImage = UIImage(named: "hoodie3")
                    return uiImage
                }
                let uiImage = UIImage(named: "jacket2")
                return uiImage
            case "Shoes":
                let randomVal = Int.random(in: 1...8)
                if randomVal == 1 {
                    let uiImage = UIImage(named: "shoes")
                    return uiImage
                }
                if randomVal == 2 {
                    let uiImage = UIImage(named: "shoes2")
                    return uiImage
                }
                if randomVal == 3 {
                    let uiImage = UIImage(named: "shoes3")
                    return uiImage
                }
                if randomVal == 4 {
                    let uiImage = UIImage(named: "shoes4")
                    return uiImage
                }
                if randomVal == 5 {
                    let uiImage = UIImage(named: "shoes5")
                    return uiImage
                }
                if randomVal == 6 {
                    let uiImage = UIImage(named: "shoes6")
                    return uiImage
                }
                if randomVal == 7 {
                    let uiImage = UIImage(named: "shoes7")
                    return uiImage
                }
                let uiImage = UIImage(named: "shoes8")
             return uiImage
           default:
                let uiImage = UIImage(named: "shirt2")
                return uiImage
            }
        }
    
//    func convertImageToUIImage(_ image: Image) -> UIImage {
//        // Create a hosting controller
//        let viewController = UIHostingController(rootView: image)
//
//        // Get the image from the hosting controller's view
//        let view = viewController.view
//
//        // Render view to an image
//        let renderer = UIGraphicsImageRenderer(size: view!.bounds.size)
//        let uiImage = renderer.image { ctx in
//            view!.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
//        }
//
//        return uiImage
//    }

    func uploadClothImage() -> String {
        guard selectedImage != nil else {
            print("Image not selected in AddClothes!")
            return ""
        }
        
        //create storage reference
        let storageRef = Storage.storage().reference()
        
        // turn image into data (please work)
        let imageData = selectedImage!.pngData()
        
        guard imageData != nil else {
            print("failed")
            return ""
        }
        // specify filepath and name
        let path = "clothes/\(UUID().uuidString).png"
        let fileRef = storageRef.child(path)
        
        // Upload dis data
        if let selectedImage = selectedImage {
            let resizedImage = selectedImage.resizedImageWithinRect(rectSize: CGSize(width: 200, height: 200)) //check size stuff after
            if let imageData = resizedImage.jpegData(compressionQuality: 0.75) {
                let uploadTask = fileRef.putData(imageData, metadata: nil) {
                    metadata, error in
                    
                    if error == nil && metadata != nil {
                        print("Successfully stored image")
                    }
                    else {
                        print("failed storing image")
                    }
                }
            }
        }
        return path
    }


    
    var body: some View {
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false){
                    VStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(height: UIScreen.main.bounds.height / 7)
                            .ignoresSafeArea(.all)
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220, height: 220)
                                .padding(.bottom, 20)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(hex: "E1DDED"))
                                .frame(width: 220, height: 220)
                                .padding(.bottom, 20)
                                .overlay(
                            Text("Upload Image Below")
                                .foregroundColor(.black)
                                .font(.system( size: 20))
                                )
                        }
                        
                        Button(action: {
                            self.isImagePickerPresented = true
                        }) {
                            Image(systemName: "square.and.arrow.up.circle.fill")
                                .resizable()
                                .foregroundColor(Color(hex: "9278E0"))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .padding(.bottom, 20)
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            PhotoPicker(image: $selectedImage) {
                                // Handle dismiss action if needed
                            }
                        }
                        
                        VStack (alignment: .leading, spacing: 10){
                            Text("Item Name")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.system( size: 18))
                                .padding(.leading, 5)
                            ZStack {
                                        TextField("", text: $searchText, onEditingChanged: { editing in
                                            isEditing = editing
                                        }).onChange(of: searchText) { newValue in
                                            if newValue.count > 20 {
                                                searchText = String(newValue.prefix(20))
                                            }
                                        }

                                        .frame(width: UIScreen.main.bounds.width - 90, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(hex: "E1DDED"))
                                                .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                                                .shadow(radius: 4)
                                        )
                                        .overlay(
                                            HStack {
                                                Text("Name...")
                                                    .foregroundColor(.black)
                                                Spacer()
                                            }
                                            .opacity(isEditing || !searchText.isEmpty ? 0 : 1)
                                        )
                            }
                            .padding(.horizontal,25)
                                .padding(.vertical, 10)
                            
                            CustomDropDown(title: "Size", prompt: "Choose your size...", options: sizeOptions, selection: $selectedSize)
                            Text("Brand")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.system( size: 18))
                                .padding(.leading, 5)
                            ZStack {
                                        TextField("", text: $searchText2, onEditingChanged: { editing in
                                            isEditing2 = editing
                                        })
                                        .onChange(of: searchText2) { newValue in
                                                if newValue.count > 20 {
                                                    searchText2 = String(newValue.prefix(20))
                                                }
                                            }
                                        .frame(width: UIScreen.main.bounds.width - 90, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(hex: "E1DDED"))
                                                .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                                                .shadow(radius: 4)
                                        )
                                        .overlay(
                                            HStack {
                                                Text("Brand...")
                                                    .foregroundColor(.black)
                                                Spacer()
                                            }
                                            .opacity(isEditing2 || !searchText2.isEmpty ? 0 : 1)
                                        )
                            }.padding(.horizontal,25)
                                .padding(.vertical, 10)
                            
                            CustomDropDown(title: "Type", prompt: "Choose your type", options: typeOptions, selection: $selectedType)
                            Rectangle()
                                .foregroundColor(Color.white)
                                .frame(height: 200)
                                .ignoresSafeArea(.all)
                        }
                        .padding(.horizontal)
                    }
                }
                Rectangle()
                    .foregroundColor(color)
                    .frame(height: UIScreen.main.bounds.height / 8)
                    .ignoresSafeArea(.all)
                HStack {
                    Button(action: {
                        if selectedImage == nil  {
                            selectedImage = getImageForSelectedType()
                        }
                        let path = uploadClothImage()
                        let colors = selectedImage?.getColors()
                        color = Color((colors?.background)!) ?? Color(hex: "9278E0")
                        if let backgroundColor = colors?.background {
                            let hexString = backgroundColor.toHex()
                            selectedColor = hexString ?? "9278E0"
                            //print(hexString)
                        }
                        if searchText == "" || searchText2 == "" || selectedType == nil || selectedColor == nil || selectedSize == nil {
                            showAlert = true
                        }
                         else if path == "" {
                            showAlert = true
                             alertMessage = "Photo upload failed"
                         } else {
                             let cloth = Cloth(name: searchText, type: selectedType, size: selectedSize, color: selectedColor, brand: searchText2, image: path, tags: ["casual", "sport"])
                             
                             let clothViewModel = ClothViewModel()
                             
                             clothViewModel.addClothToCurrentUser(cloth: cloth)
                             presentationMode.wrappedValue.dismiss()
                         }
                        
                    }) {
                        Text("Add")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.leading, 15)
                            .font(.system(size: 12))
                    }
                    Spacer()
                    Text("New Item")
                        .foregroundColor(.white)
                        .font(.system( size: 20))
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(.trailing, 15)
                                        .font(.system( size: 12))
                                }
                }.padding(.top, 20)
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
}


struct AddClothesView_Previews: PreviewProvider {
    static var previews: some View {
        AddClothes()
    }
}
