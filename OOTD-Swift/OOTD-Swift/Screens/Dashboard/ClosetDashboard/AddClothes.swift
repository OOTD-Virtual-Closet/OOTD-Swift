//
//  AddClothes.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/27/24.
//


import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct AddClothes: View {
    @Environment(\.presentationMode) var presentationMode

    private var sizeOptions = ["XS", "S", "M", "L", "XL", "XXL"]
    private var typeOptions = ["Tops", "Bottoms", "Jackets/Hoodies", "Shoes"]
    private var colorOptions = ["Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Indigo", "Violet", "Tomato Red", "Greenish Cob"]
    @State private var isEditing = false
    @State private var isEditing2 = false


    @State private var name : String?
    @State var selectedImage: UIImage?
    @State private var selectedType : String?
    @State private var selectedSize : String?
    @State private var selectedColor : String?
    @State private var searchText = ""
    
    @State private var searchText2 = ""
    
    @State var showAlert = false
    @State var alertMessage = "Please fill out all fields"
    
    func getImageForSelectedType() -> UIImage? {
            guard let selectedType = selectedType else {
                return nil
            }
            
            switch selectedType {
            case "Tops":
                var randomVal = Int.random(in: 1...3)
                if randomVal == 1 {
                    var image = Image("shirt")
                    let uiImage = convertImageToUIImage(image)
                    return uiImage
                }
                if randomVal == 2 {
                    var image = Image("shirt2")
                    let uiImage = convertImageToUIImage(image)
                    return uiImage
                }
                var image = Image("shirt3")
                let uiImage = convertImageToUIImage(image)
                return uiImage
            case "Bottoms":
                var image = Image("jeans")
                let uiImage = convertImageToUIImage(image)
                return uiImage
            case "Jackets/Hoodies":
                var randomVal = Int.random(in: 1...3)
                if randomVal == 1 {
                    var image = Image("jacket")
                    let uiImage = convertImageToUIImage(image)
                    return uiImage
                }
                if randomVal == 2 {
                    var image = Image("hoodie")
                    let uiImage = convertImageToUIImage(image)
                    return uiImage
                }
                var image = Image("jacket")
                let uiImage = convertImageToUIImage(image)
                return uiImage
            case "Shoes":
                var image = Image("hoodie")
                let uiImage = convertImageToUIImage(image)
                return uiImage
            default:
                return nil
            }
        }
    func convertImageToUIImage(_ image: Image) -> UIImage {
        // Create a hosting controller
        let viewController = UIHostingController(rootView: image)

        // Get the image from the hosting controller's view
        let view = viewController.view

        // Render view to an image
        let renderer = UIGraphicsImageRenderer(size: view!.bounds.size)
        let uiImage = renderer.image { ctx in
            view!.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }

        return uiImage
    }

    func uploadImage() -> String {
        guard selectedImage != nil else {
            return ""
        }
        
        //create storage reference
        let storageRef = Storage.storage().reference()
        
        // turn image into data (please work)
        let imageData = selectedImage!.pngData()
        
        guard imageData != nil else {
            return ""
        }
        // specify filepath and name
        let path = "images/\(UUID().uuidString).png"
        let fileRef = storageRef.child(path)
        
        // Upload dis data
        
        let uploadTask = fileRef.putData(imageData!, metadata: nil) {
            metadata, error in
            
            if error == nil && metadata != nil {
                print("Successfully stored image")
            }
            else {
                print("failed storing image")
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
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(hex: "E1DDED"))
                            .frame(width: 220, height: 220)
                            .padding(.bottom, 20)
                           .overlay(
                            Text("Upload Image Below")
                                .foregroundColor(.black)
                                .font(.system( size: 20))
                           )
                        Image(systemName: "square.and.arrow.up.circle.fill")
                            .resizable()
                            .foregroundColor(Color(hex: "9278E0"))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .padding(.bottom, 20)
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
                            CustomDropDown(title: "Color", prompt: "Color of Clothing", options: colorOptions, selection: $selectedColor)
                            
                            Rectangle()
                                .foregroundColor(Color.white)
                                .frame(height: 200)
                                .ignoresSafeArea(.all)
                        }
                        .padding(.horizontal)
                    }
                }
                Rectangle()
                    .foregroundColor(Color(hex: "9278E0"))
                    .frame(height: UIScreen.main.bounds.height / 8)
                    .ignoresSafeArea(.all)
                HStack {
                    Button(action: {
                        let image = getImageForSelectedType()
                        let path = uploadImage()
                        
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
