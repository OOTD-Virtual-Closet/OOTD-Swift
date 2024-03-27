import SwiftUI

struct ClothingItem: Codable {
    let name:String
    let price:String
    let imageURL: URL
}

struct CategoriesView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var showPopUp = false
    @State private var selectedCategory: String?
    @State private var isLoading = false
    @State private var clothingItems: [ClothingItem] = []
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    let categories = ["Shirts", "Jackets", "Shoes", "Pants", "Hats"]
    
    
    //    var filteredItems: [ClothingItemElements] {
    //        if let selectedCategory = selectedCategory {
    //            return clothingItems.filter { $0.name == selectedCategory }
    //        } else {
    //            return clothingItems
    //        }
    //    }
    
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
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    ForEach(clothingItems, id: \.name) {item in
                        ClothingTileView(item: item)
                    }
                }
            }
        }
        .onAppear {
            fetchClothingItems()
        }
    }
    func fetchClothingItems() {
        isLoading = true
        let headers = [
            "X-RapidAPI-Key": "7e761747e3msh0b7e60525a8cee7p17fdd2jsn0647c8fd67f0",
            "X-RapidAPI-Host": "asos-com1.p.rapidapi.com"
        ]
        guard let url = URL(string: "https://asos-com1.p.rapidapi.com/products/detail?url=only-sons%2Fonly-sons-oversized-twill-worker-jacket-in-camo%2Fprd%2F203998871") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse)
            }
            
            do {
                        let clothingItemDetail = try JSONDecoder().decode(ClothingItem.self, from: data)
                        DispatchQueue.main.async {
                            // Update UI to display the clothing item detail
                            self.clothingItems = [clothingItemDetail]
                            self.isLoading = false
                        }
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
        }.resume()
    }
}


struct ClothingTileView: View {
    let item: ClothingItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: item.imageURL)
                .frame(width: 150, height:200)
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

struct AsyncImage: View {
    @StateObject private var imageLoader = ImageLoader2()
    let url: URL
    
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView()
                .onAppear {
                    imageLoader.loadImage(from: url)
                }
        }
    }
}

class ImageLoader2: ObservableObject {
    @Published var image: UIImage?
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
