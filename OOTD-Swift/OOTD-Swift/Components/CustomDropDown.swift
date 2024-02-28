//
//  CustomDropDown.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/28/24.
//

import SwiftUI


struct CustomDropDown: View {
    let title: String
    let prompt: String
    let options: [String]
    
    @State private var isExpanded = false
    @Binding var selection: String?
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(title)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .font(.system( size: 18))
                .opacity(0.8)
            
            VStack {
                Button(action: {withAnimation(.snappy) {isExpanded.toggle()}
                }) {
                                HStack {
                                    Text(selection ?? prompt)
                                        .foregroundStyle(Color.black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                        .rotationEffect(.degrees(isExpanded ? -180 : 0))
                                }
                                .frame(height: 50)
                                .padding(.horizontal, 15)
                            }                
                if isExpanded {
                    VStack {
                        ForEach(options, id: \.self) {
                            option in
                            Button(action: {
                                withAnimation(.snappy) {
                                    selection = option
                                    isExpanded.toggle()}
                            }) {HStack {
                                Text(option)
                                    .foregroundStyle(selection == option ? Color.black : .gray)
                                Spacer()
                                
                                if selection == option {
                                    Image(systemName: "checkmark")
                                        .font(.subheadline)
                                    
                                }
                            }
                                
                            }
                            .frame(height: 50)
                            .padding(.horizontal, 15)           
                        }
                    }.transition(.move(edge: .bottom))
                    
                }
            }
            .background(Color(hex:"E1DDED"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 4)
            .frame(width: UIScreen.main.bounds.width - 40)
        }
    }
}



struct CustomDropdownPreview: PreviewProvider {
    static var previews: some View {
        CustomDropDown(title: "Size", prompt: "Select a size...", options: ["XS", "S"], selection: .constant("S"))
    }
}
