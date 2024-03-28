
//
//  TrendingView.swift
//  OOTD-Swift
//
//  Created by Aditya Patel on 2/17/24.
//

import SwiftUI
import FirebaseStorage

struct TrendingView: View {
    @State private var currentIndex = 0
    @State private var isShowingDetails = false
    @State private var isShowingCart = false
    let clothData: [Int: [String: String]] = [
        1163: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Blue", "productDisplayName": "Nike Sahara Team India Fanwear Round Neck Jersey"],
        1164: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Blue", "productDisplayName": "Nike Men Blue T20 Indian Cricket Jersey"],
        1165: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Blue", "productDisplayName": "Nike Mean Team India Cricket Jersey"],
        1525: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Navy Blue", "productDisplayName": "Puma Deck Navy Blue Backpack"],
        1526: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Black", "productDisplayName": "Puma Big Cat Backpack Black"],
        1528: ["subCategory": "Topwear", "articleType": "Jackets", "baseColour": "Black", "productDisplayName": "Puma Men Ferrari Black Fleece Jacket"],
        1529: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Red", "productDisplayName": "Ferrari Tee"],
        1530: ["subCategory": "Topwear", "articleType": "Jackets", "baseColour": "Red", "productDisplayName": "Puma Men Ferrari Track Jacket"],
        1531: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Grey", "productDisplayName": "Puma Men Grey Solid Round Neck T-Shirt"],
        1532: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Grey", "productDisplayName": "Puma Men Grey Leaping Cat T-shirt"],
        1533: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Red", "productDisplayName": "Puma Men Cat Red T-shirt"],
        1534: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Black", "productDisplayName": "Puma Men Black Leaping Cat T-shirt"],
        1535: ["subCategory": "Headwear", "articleType": "Caps", "baseColour": "Black", "productDisplayName": "Puma Unisex Logo Cap"],
        1536: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Black", "productDisplayName": "Puma Men Black Net Jersey"],
        1537: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Red", "productDisplayName": "Puma Men Red Net Jersey"],
        1538: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Blue", "productDisplayName": "Puma Men Ferrari Track Black T-shirt"],
        1539: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Grey", "productDisplayName": "Puma Men Ferrari Grey T-shirt"],
        1540: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Blue", "productDisplayName": "Puma Men Ferrari Vintage Black Polo T-shirt"],
        1541: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Puma Men's Ballistic Spike White Green Shoe"],
        1542: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Puma Men's Ballistic Rubber Shoe"],
        1543: ["subCategory": "Shoes", "articleType": "Casual Shoes", "baseColour": "Black", "productDisplayName": "Puma Men Basket-Biz Sneaker"],
        1544: ["subCategory": "Shoes", "articleType": "Casual Shoes", "baseColour": "White", "productDisplayName": "Puma Men's Basket Bump Sneaker"],
        1545: ["subCategory": "Shoes", "articleType": "Casual Shoes", "baseColour": "White", "productDisplayName": "Puma Men's Speed Cat Shoe"],
        1546: ["subCategory": "Shoes", "articleType": "Casual Shoes", "baseColour": "White", "productDisplayName": "Puma Men's Furore White Shoe"],
        1547: ["subCategory": "Shoes", "articleType": "Casual Shoes", "baseColour": "Black", "productDisplayName": "Puma Men's Ducati Sneaker"],
        1548: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Puma Men's Cell Exsis Sneaker"],
        1549: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Puma Men's Jiyu Slip On Sneaker"],
        1550: ["subCategory": "Sports Equipment", "articleType": "Footballs", "baseColour": "White", "productDisplayName": "Puma Cat Trainer-WBL Football"],
        1551: ["subCategory": "Sports Equipment", "articleType": "Footballs", "baseColour": "Orange", "productDisplayName": "Puma Power Cat Trainer-OB Football"],
        1552: ["subCategory": "Sports Equipment", "articleType": "Footballs", "baseColour": "White", "productDisplayName": "Puma Power Cat Trainer-WR Football"],
        1553: ["subCategory": "Sports Equipment", "articleType": "Footballs", "baseColour": "White", "productDisplayName": "Puma Power Cat Hard Ground Football"],
        1554: ["subCategory": "Water Bottle", "articleType": "Water Bottle", "baseColour": "Blue", "productDisplayName": "Quechua Blue Sipper"],
        1555: ["subCategory": "Water Bottle", "articleType": "Water Bottle", "baseColour": "Purple", "productDisplayName": "Quechua Red Sipper"],
        1556: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Black", "productDisplayName": "Quechua Forclaz Large Backpack - 50 ltr Orange"],
        1557: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Black", "productDisplayName": "Quechua Spacious Blue-Black Backpack"],
        1558: ["subCategory": "Water Bottle", "articleType": "Water Bottle", "baseColour": "Blue", "productDisplayName": "Quechua Easy-to-Carry Blue Water Bottle"],
        1559: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Blue", "productDisplayName": "Quechua Blue Light Backpack"],
        1561: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "White", "productDisplayName": "Quechua Women Sweat Proof White T-shirt"],
        1562: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Grey", "productDisplayName": "Quechua Men Sweat Proof Grey T-shirt"],
        1563: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Blue", "productDisplayName": "Quechua Men Sweat Proof Blue T-shirt"],
        1565: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Green", "productDisplayName": "Quechua Green Light Backpack"],
        1566: ["subCategory": "Headwear", "articleType": "Caps", "baseColour": "Black", "productDisplayName": "Artengo Men Black Cap"],
        1567: ["subCategory": "Bottomwear", "articleType": "Shorts", "baseColour": "Black", "productDisplayName": "Artengo Men Training Shorts"],
        1569: ["subCategory": "Bottomwear", "articleType": "Shorts", "baseColour": "Black", "productDisplayName": "Artengo Men Black Tennis Shorts"],
        1570: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Black", "productDisplayName": "Artengo Women Tennis Singlet"],
        1571: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Kalenji Men's Super Soft Sports Shoes"],
        1572: ["subCategory": "Bottomwear", "articleType": "Track Pants", "baseColour": "Black", "productDisplayName": "Kalenji Mens Essential Training Track Pants"],
        1573: ["subCategory": "Bottomwear", "articleType": "Track Pants", "baseColour": "Grey", "productDisplayName": "Kalenji Women Athletes Grey Track Pants"],
        1575: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "White", "productDisplayName": "Kipsta Men Sports White T-shirt"],
        1577: ["subCategory": "Headwear", "articleType": "Caps", "baseColour": "Green", "productDisplayName": "Inesis Slim Shady Cap"],
        1578: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Red", "productDisplayName": "Domyos Men Good Stroke Red T-shirt"],
        1579: ["subCategory": "Topwear", "articleType": "Jackets", "baseColour": "Grey", "productDisplayName": "Domyos Men Grey Second Skin Jacket"],
        1580: ["subCategory": "Bottomwear", "articleType": "Swimwear", "baseColour": "Black", "productDisplayName": "Nabaiji Women Cross-back Swimsuit"],
        1581: ["subCategory": "Headwear", "articleType": "Caps", "baseColour": "Pink", "productDisplayName": "Nabaiji Unisex Silicone Swimming Cap"],
        1582: ["subCategory": "Bottomwear", "articleType": "Swimwear", "baseColour": "Black", "productDisplayName": "Nabaiji Unisex Black Silicone Swimming Cap"],
        1583: ["subCategory": "Bottomwear", "articleType": "Swimwear", "baseColour": "Black", "productDisplayName": "Nabaiji Women Black Swimsuit"],
        1584: ["subCategory": "Topwear", "articleType": "Jackets", "baseColour": "White", "productDisplayName": "Domyos Unisex Feather-light Jacket"],
        1587: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Kipsta Men Superfit Football White Shoe"],
        1588: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "White", "productDisplayName": "Domyos Men White Dry-Fit T-shirt"],
        1590: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "Black", "productDisplayName": "Kipsta Men's F300 Football Shoe"],
        1591: ["subCategory": "Bottomwear", "articleType": "Shorts", "baseColour": "Red", "productDisplayName": "Kipsta Men Red Shorts"],
        1592: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "Red", "productDisplayName": "Kipsta Men's Superfit Football Red Shoe"],
        1594: ["subCategory": "Shoes", "articleType": "Casual Shoes", "baseColour": "Grey", "productDisplayName": "Newfeel Unisex Grey Mesh Lightweight Shoe"],
        1595: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Black", "productDisplayName": "Domyos Men Good Stroke Black T-shirt"],
        1596: ["subCategory": "Water Bottle", "articleType": "Water Bottle", "baseColour": "Pink", "productDisplayName": "Quechua Easy-to-Carry Pink Sipper"],
        1597: ["subCategory": "Bags", "articleType": "Handbags", "baseColour": "Black", "productDisplayName": "Geonaute Women Black Outdoor Bag"],
        1598: ["subCategory": "Bags", "articleType": "Handbags", "baseColour": "Blue", "productDisplayName": "Geonaute Women Blue Outdoor Bag"],
        1599: ["subCategory": "Bags", "articleType": "Handbags", "baseColour": "Green", "productDisplayName": "Geonaute Women Green Outdoor Bag"],
        1603: ["subCategory": "Topwear", "articleType": "Sweatshirts", "baseColour": "Navy Blue", "productDisplayName": "Reebok Men Hoops Athletic Navy Sweatshirt"],
        1604: ["subCategory": "Bottomwear", "articleType": "Track Pants", "baseColour": "Blue", "productDisplayName": "Reebok Track Pants Women Blue"],
        1605: ["subCategory": "Bottomwear", "articleType": "Track Pants", "baseColour": "Black", "productDisplayName": "Reebok Black Track Pant"],
        1607: ["subCategory": "Bottomwear", "articleType": "Track Pants", "baseColour": "Blue", "productDisplayName": "Reebok Men trackpant- male Track Pants"],
        1608: ["subCategory": "Bottomwear", "articleType": "Track Pants", "baseColour": "Blue", "productDisplayName": "Reebok Track Pants Jet Black"],
        1609: ["subCategory": "Topwear", "articleType": "Sweatshirts", "baseColour": "Pink", "productDisplayName": "Reebok Women Boat-Neck Wildberry Sweatshirt"],
        1610: ["subCategory": "Topwear", "articleType": "Jackets", "baseColour": "Navy Blue", "productDisplayName": "Reebok Navy Jacket"],
        1611: ["subCategory": "Topwear", "articleType": "Jackets", "baseColour": "Black", "productDisplayName": "Reebok Knit Rib Women Black Jacket"],
        1612: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "White", "productDisplayName": "Reebok Orange & White Striped Polo T-shirt"],
        1613: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "White", "productDisplayName": "Reebok Men White Polo Tshirt"],
        1614: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "White", "productDisplayName": "Reebok T-shirt White Polo Tshirt"],
        1615: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Navy Blue", "productDisplayName": "Reebok Men Navy Blue Polo T-shirt"],
        1616: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "White", "productDisplayName": "Reebok Men's Shoot White T-Shirt"],
        1617: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Red", "productDisplayName": "Reebok Men Shoot T-Shirt Red"],
        1618: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Reebok Men United Runner White"],
        1619: ["subCategory": "Bottomwear", "articleType": "Shorts", "baseColour": "Grey", "productDisplayName": "Reebok Men Micro Shorts Grey and White"],
        1620: ["subCategory": "Bottomwear", "articleType": "Shorts", "baseColour": "Blue", "productDisplayName": "Reebok Men Micro Shorts"],
        1621: ["subCategory": "Bottomwear", "articleType": "Shorts", "baseColour": "Grey", "productDisplayName": "Reebok Men Micro Shorts Black and White"],
        1622: ["subCategory": "Topwear", "articleType": "Jackets", "baseColour": "Navy Blue", "productDisplayName": "Reebok Navy Knit Rib Jacket"],
        1623: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Red", "productDisplayName": "Reebok Unisex Red Backpack"],
        1624: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Black", "productDisplayName": "Reebok Silver-Black Laptop Backpack"],
        1625: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Red", "productDisplayName": "Domyos Men Quick Dry T-shirt"],
        1626: ["subCategory": "Sports Equipment", "articleType": "Footballs", "baseColour": "Blue", "productDisplayName": "Kipsta F300 Football Size 5 Football"],
        1627: ["subCategory": "Sports Equipment", "articleType": "Footballs", "baseColour": "White", "productDisplayName": "Kipsta F300 Football"],
        1628: ["subCategory": "Sports Equipment", "articleType": "Basketballs", "baseColour": "Brown", "productDisplayName": "Kipsta Xtra Bounce Basketball"],
        1634: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Inesis Water Repellent Canaveral Shoes"],
        1635: ["subCategory": "Shoes", "articleType": "Casual Shoes", "baseColour": "Red", "productDisplayName": "Newfeel Unisex Red Comfy Shoes"],
        1636: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Nike Men Air Zoom Century Shoes"],
        1637: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Nike Men White Cricket Shoes"],
        1638: ["subCategory": "Bottomwear", "articleType": "Swimwear", "baseColour": "Blue", "productDisplayName": "Nabaiji Swimming Goggles Blue Black"],
        1641: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "Silver", "productDisplayName": "Reebok Men's Hex Run Pure Silver Shoe"],
        1642: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Reebok Men Winning Stride White Red"],
        1644: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Red", "productDisplayName": "Kipsta Men Loose Fit Round Neck Jersey Red"],
        1645: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Black", "productDisplayName": "Kipsta Men Loose Fit Round Neck Jersey Black"],
        1646: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Grey", "productDisplayName": "Quechua Ultralight Backpack 16 Ltr Grey Bag"],
        1647: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Green", "productDisplayName": "Quechua Unisex Ultralight 16 Ltr Green Backpack"],
        1648: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Pink", "productDisplayName": "Quechua  Ultralight Backpack Purple 16 ltr Bag"],
        1649: ["subCategory": "Shoes", "articleType": "Casual Shoes", "baseColour": "Blue", "productDisplayName": "Newfeel Unisex Comfy Cool Blue Shoe"],
        1651: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Pink", "productDisplayName": "Domyos Women Style Pink T-shirt"],
        1653: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "Brown", "productDisplayName": "Reebok Men's Ventilator Ubiq Shoe"],
        1654: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Reebok Men's Frisker LP Shoe"],
        1656: ["subCategory": "Headwear", "articleType": "Caps", "baseColour": "Blue", "productDisplayName": "Nike Unisex Odi Day Cap"],
        1657: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Reebok Men's White High Wire Shoe"],
        1658: ["subCategory": "Topwear", "articleType": "Jackets", "baseColour": "Blue", "productDisplayName": "Nike Men Windrunner Blue Jacket"],
        1662: ["subCategory": "Topwear", "articleType": "Jackets", "baseColour": "Navy Blue", "productDisplayName": "Nike Men Blue Windrunner Jacket"],
        1668: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Red", "productDisplayName": "Reebok Men Playdry Full Sleeved T-shirt Red"],
        1670: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Grey", "productDisplayName": "Reebok Men Green Polo T-shirt"],
        1671: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Black", "productDisplayName": "Reebok Men Black Polo T-shirt"],
        1673: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Black", "productDisplayName": "Reebok Mens Lagoon Black T-shirt"],
        1678: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Green", "productDisplayName": "Reebok Men Play Hard Cotton Green T-shirt"],
        1689: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Blue", "productDisplayName": "Reebok Men Blue Polo T-shirt"],
        1697: ["subCategory": "Bags", "articleType": "Backpacks", "baseColour": "Black", "productDisplayName": "Puma Deck Black Backpack"],
        1727: ["subCategory": "Shoes", "articleType": "Casual Shoes", "baseColour": "Black", "productDisplayName": "Newfeel Unisex Black Lightweight Shoes"],
        1728: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "Green", "productDisplayName": "Newfeel Unisex Green Sports Shoes"],
        1729: ["subCategory": "Shoes", "articleType": "Casual Shoes", "baseColour": "White", "productDisplayName": "Newfeel Unisex White Shoes"],
        1730: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "Black", "productDisplayName": "Reebok Women Black Pink Frisker Shoe"],
        1731: ["subCategory": "Shoes", "articleType": "Sports Shoes", "baseColour": "White", "productDisplayName": "Reebok Women White Blue Frisker Shoes"],
        1752: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Red", "productDisplayName": "Lotto Men Red Epic T-shirt"],
        1754: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Black", "productDisplayName": "Lotto Men Marcello Black T-shirt"],
        1755: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Red", "productDisplayName": "Lotto Men Jasper Street Red T-shirt"],
        1756: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "White", "productDisplayName": "Lotto Men White Polo T-shirt"],
        1757: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Black", "productDisplayName": "Lotto Men Polo Slate Black Rugby T-shirt"],
        1758: ["subCategory": "Topwear", "articleType": "Jackets", "baseColour": "White", "productDisplayName": "Lotto Men White Collared Jacket"],
        1759: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Grey", "productDisplayName": "Lotto Men Epic Grey T-shirt"],
        1760: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "White", "productDisplayName": "Lotto Men Marcello White T-shirt"],
        1762: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Blue", "productDisplayName": "Lotto Women Cathy Blue T-shirt"],
        1763: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Pink", "productDisplayName": "Lotto Women Cathy Pink T-shirt"],
        1764: ["subCategory": "Bottomwear", "articleType": "Track Pants", "baseColour": "Black", "productDisplayName": "Lotto Women Mid Cathy Track Pants"],
        1765: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "White", "productDisplayName": "Lotto Women White T-shirt"],
        1766: ["subCategory": "Topwear", "articleType": "Tshirts", "baseColour": "Blue", "productDisplayName": "Inesis Men Blue Polo T-shirt"]
    ]
    @State private var cartItems: [ClothingElements] = []
    
    var body: some View {
        VStack {
            Text("\(cartItems.count) items")
                .foregroundColor(.gray)
                .font(.system( size: 13))
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                .padding(.leading, 10)
                .padding(.top, 10)
            HStack {
                
                Button(action: {
                    isShowingCart.toggle()
                }) {
                    Image(systemName: "cart.fill")
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $isShowingCart) {
                    ShoppingCartView(cartItems: cartItems)
                }
                Text("Wish List")
                    .foregroundColor(.black)
                    .font(.system( size: 18))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
            }
            .padding(.leading, 35)
            .padding(.bottom, 20)
            //            Spacer()
            
            Button(action: {
                isShowingDetails = true
            }) {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.uIpurple.opacity(0.6))
                    .frame(width: 210, height: 310)
                    .overlay(
                        Image(clothData[clothData.keys.sorted()[currentIndex]]?["image"] ?? "default_image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 275)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    )
                    .padding(.bottom, 30)
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    withAnimation {
                        currentIndex = max(currentIndex - 1, 0)
                    }
                }) {
                    Text("Back")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    withAnimation {
                        currentIndex = min(currentIndex + 1, clothData.count - 1)
                    }
                }) {
                    Text("Next")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.uIpurple)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            //            .padding(.horizontal, 25)
            Spacer()
        }
        .sheet(isPresented: $isShowingDetails) {
            if let itemData = clothData[clothData.keys.sorted()[currentIndex]] {
                ClothingItemDetailsView(item: ClothingElements(id: "\(clothData.keys.sorted()[currentIndex])",
                                                    subCategory: itemData["subCategory"] ?? "Unknown",
                                                    articleType: itemData["articleType"] ?? "Unknown",
                                                    baseColor: itemData["baseColour"] ?? "Unknown",
                                                    displayName: itemData["productDisplayName"] ?? "Unknown"),
                                        addToCart: { item in
                    cartItems.append(item)
                    print("Item added to cart: \(item.displayName)")
                    print(itemData.values)
                    if let index = clothData.keys.sorted().firstIndex(of: Int(item.id) ?? 0) {
                        currentIndex = index
                    }
                })
            }
        }


    }
}
struct ShoppingCartView: View {
    var cartItems: [ClothingElements]
    
    var body: some View {
        VStack {
            Text("Wish List")
                .font(.title)
                .fontWeight(.bold)
            List {
                ForEach(cartItems) { item in
                    Text(item.displayName)
                }
            }
            Spacer()
        }
    }
}

struct ClothingItemDetailsView: View {
    @StateObject private var imageLoader = ImageLoader()
    var item: ClothingElements
    var addToCart: (ClothingElements) -> Void
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 300)
                    .cornerRadius(25)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 150, height: 200)
                    .cornerRadius(25)
            }
            
            HStack {
                Text(item.subCategory)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .padding()
                Text(item.subCategory)
                    .fontWeight(.heavy)
                Spacer()
            }
            .padding(.leading, 20)
            
            HStack {
                Text(item.articleType)
                    .fontWeight(.medium)
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.leading, 20)
            HStack {
                Text("Color")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .padding()
                Spacer()
            }
            .padding(.leading, 20)
            HStack {
                Circle()
                    .fill(Color(item.baseColor))
                    .frame(width: 24, height: 24)
                Spacer()
            }
            .padding(.leading, 40)
            HStack {
                Text("Size")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .padding()
                Spacer()
            }
            .padding(.leading, 20)
            HStack {
                Circle()
                    .foregroundColor(Color(hex:"F6F6F6"))
                    .overlay(
                        Text("XS")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .frame(width: 40, height: 40)
                Circle()
                    .foregroundColor(Color(hex:"F6F6F6"))
                    .overlay(
                        Text("S")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .frame(width: 40, height: 40)
                Circle()
                    .foregroundColor(Color(hex:"F6F6F6"))
                    .overlay(
                        Text("M")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .frame(width: 40, height: 40)
                Circle()
                    .foregroundColor(Color(hex:"F6F6F6"))
                    .overlay(
                        Text("L")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .frame(width: 40, height: 40)
                Circle()
                    .foregroundColor(Color(hex:"F6F6F6"))
                    .overlay(
                        Text("XL")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .frame(width: 40, height: 40)
                Spacer()
            }
            .padding(.leading, 40)
            HStack {
                Button(action: {
                    print("Cancel")
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(Color(hex:"EF5B5B"))
                        .cornerRadius(15)
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                Button(action: {
                    print("Add to Cart")
                    addToCart(item)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add to WishList")
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(Color(hex:"FFBA49"))
                        .cornerRadius(15)
                }
                .padding(.top, 10)
                .padding(.leading, 10)
            }
            Spacer()
        }
        .padding()
        .onAppear{
            fetchClothImages{
                print("Success Clothes Images uploaded")
            }
        }
    }
    func fetchClothImages(completion: @escaping () -> Void) {
        let storageRef = Storage.storage().reference()
        storageRef.child("clothesDataset/\(item.id).jpg").downloadURL { url, error in
            if let url = url {
                // Load image using image loader
                imageLoader.loadImage(from: url)
            } else if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            }
            completion() // Call completion handler after fetching image
        }
    }
}
struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
