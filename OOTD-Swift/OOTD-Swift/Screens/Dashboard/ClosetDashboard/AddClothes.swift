//
//  AddClothes.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/27/24.
//


import SwiftUI

struct AddClothes: View {
    private var sizeOptions = ["XS", "S", "M", "L", "XL", "XXL"]
    private var typeOptions = ["Tops", "Bottoms", "Jackets/Hoodies", "Shoes"]
    private var colorOptions = ["Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Indigo", "Violet", "Tomato Red", "Greenish Cob"]
    @State private var isEditing = false
    @State private var isEditing2 = false


    @State private var name : String?
    @State private var selectedType : String?
    @State private var selectedSize : String?
    @State private var selectedColor : String?
    @State private var searchText = ""
    
    @State private var searchText2 = ""
    


    
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
                                        })
                                        .padding(.leading, 15)
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
                            }.padding(.horizontal,25)
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
                                        .padding(.leading, 15)
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
                    .frame(height: UIScreen.main.bounds.height / 7)
                    .ignoresSafeArea(.all)
                HStack {
                    Text("Add")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.leading, 15)
                        .font(.system( size: 12))
                    Spacer()
                    Text("New Item")
                        .foregroundColor(.white)
                        .font(.system( size: 20))
                        .fontWeight(.bold)
                    Spacer()
                    Text("Cancel")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.trailing, 15)
                        .font(.system( size: 12))
                }.padding(.top, 20)
                
            }
        }
}


struct AddClothesView_Previews: PreviewProvider {
    static var previews: some View {
        AddClothes()
    }
}
