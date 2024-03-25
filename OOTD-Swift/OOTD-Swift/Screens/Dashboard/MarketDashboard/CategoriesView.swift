import SwiftUI

struct CategoriesView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var showPopUp = false
    @State private var selectedCategory: String?
    
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    let categories = ["Shirts", "Jackets", "Shoes", "Pants", "Hats"]
    
    let clothingItems: [ClothingItemElements] = [
        ClothingItemElements(name: "Shirts", descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing1", price: "$49.99", description: "A cool piece of clothing.", color: "#33673B"),
        ClothingItemElements(name: "Clothing 2", descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing2", price: "$59.99", description: "Another cool piece of clothing.", color: "#3E8989"),
        ClothingItemElements(name: "Clothing 3", descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing3", price: "$39.99", description: "Yet another cool piece of clothing.", color: "#D1B490"),
        ClothingItemElements(name: "Clothing 1", descrption: "Otton shirt. Classic sollar. Short sleeve. Cuts at the Bottoms. Button close on the front.", image: "clothing1", price: "$39.99", description: "Yet another cool piece of clothing.", color: "#D1B490")
    ]
    
    var filteredItems: [ClothingItemElements] {
        if let selectedCategory = selectedCategory {
            return clothingItems.filter { $0.name == selectedCategory }
        } else {
            return clothingItems
        }
    }
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack (alignment: .leading) {
                Text("36 items")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .padding(.top, 10)
                    .padding(.leading, 10)
                HStack {
                    Image(systemName: "cart.fill")
                    Text("Shopping Cart")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                }
                .padding(.leading, 35)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                if selectedCategory == category {
                                    // Deselect the category if it's already selected
                                    selectedCategory = nil
                                } else {
                                    selectedCategory = category
                                }
                            }) {
                                Text(category)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .foregroundColor(selectedCategory == category ? .white : .gray)
                                    .background(selectedCategory == category ? Color.black : Color.uIpurple)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                }
                
                Spacer()
                
                LazyVGrid(columns: gridItems, spacing: 20) {
                    ForEach(filteredItems) { item in
                        ClothingTileView(item: item)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
            }
        }
    }
}

struct ClothingTileView: View {
    let item: ClothingItemElements
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 200)
                .cornerRadius(25)
            
            Text(item.name)
                .font(.headline)
            
            Text(item.price)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
