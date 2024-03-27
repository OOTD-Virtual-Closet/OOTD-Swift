import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import SwiftCSV

struct ClothingElements: Identifiable {
    var id: String
    var subCategory: String
    var articleType: String
    var baseColor: String
    var displayName: String
    
    init(id: String, subCategory: String, articleType: String?, baseColor: String?, displayName: String?) {
        self.id = id
        self.subCategory = subCategory
        self.articleType = articleType ?? "Unknown"
        self.baseColor = baseColor ?? "Unknown"
        self.displayName = displayName ?? "Unknown"
    }
}
struct CategoriesView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var showPopUp = false
    @State private var numbersIndex = 0
    @State private var selectedCategory: String?
    @State private var numbers: [Int] = [
        1163, 1164, 1165, 1525, 1526, 1528, 1529, 1530, 1531, 1532, 1533, 1534, 1535, 1536, 1537, 1538, 1539, 1540, 1541, 1542, 1543, 1544, 1545, 1546, 1547, 1548, 1549, 1550, 1551, 1552, 1553, 1554, 1555, 1556, 1557, 1558, 1559, 1561, 1562, 1563, 1565, 1566, 1567, 1569, 1570, 1571, 1572, 1573, 1575, 1577, 1578, 1579, 1580, 1581, 1582, 1583, 1584, 1587, 1588, 1590, 1591, 1592, 1594, 1595, 1596, 1597, 1598, 1599, 1603, 1604, 1605, 1607, 1608, 1609, 1610, 1611, 1612, 1613, 1614, 1615, 1616, 1617, 1618, 1619, 1620, 1621, 1622, 1623, 1624, 1625, 1626, 1627, 1628, 1634, 1635, 1636, 1637, 1638, 1641, 1642, 1644, 1645, 1646, 1647, 1648, 1649, 1651, 1653, 1654, 1656, 1657, 1658, 1662, 1668, 1670, 1671, 1673, 1678, 1689, 1697, 1727, 1728, 1729, 1730, 1731, 1752, 1754, 1755, 1756, 1757, 1758, 1759, 1760, 1762, 1763, 1764, 1765, 1766]
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    let categories = ["Topwear", "Bags", "Bottomwear", "Headwear", "Shoes"]
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
    
    @State private var clothingItems: [ClothingElements] = []
    @State private var itemsToLoad = 4
    var filteredClothingItems: [ClothingElements] {
            if let selectedCategory = selectedCategory {
                return clothingItems.filter { $0.subCategory == selectedCategory }
            } else {
                return clothingItems
            }
        }
    private func loadMoreItems() {
        let endIndex = min(numbers.count, numbersIndex + itemsToLoad)
        let idsToLoad = numbers[numbersIndex..<endIndex]
        
        for id in idsToLoad {
                    let subCategory = clothData[id]?["subCategory"] ?? "Unknown"
                    let articleType = clothData[id]?["articleType"]
                    let baseColor = clothData[id]?["baseColour"]
                    let displayName = clothData[id]?["productDisplayName"]
                    
                    let clothingItem = ClothingElements(id: "\(id)", subCategory: subCategory, articleType: articleType, baseColor: baseColor, displayName: displayName)
                    
                    // Only append if no category is selected or matches the selected category
                    if selectedCategory == nil || subCategory == selectedCategory {
                        clothingItems.append(clothingItem)
                    }
                }
        
        numbersIndex = endIndex
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
                    ForEach(filteredClothingItems, id: \.id) { item in
                        ClothingTileView(item: item)
                    }
                }
                .padding()
                .onAppear {
                    loadMoreItems()
                }
                Button(action: {
                    loadMoreItems()
                }) {
                    Text("Load More")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
    }
}

struct ClothingTileView: View {
    @StateObject private var imageLoader = ImageLoader()
    let item: ClothingElements
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
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 150, height: 200)
                .cornerRadius(25)
                .overlay(
                    Group {
                        if let image = imageLoader.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 200)
                                .cornerRadius(25)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 150, height: 200)
                                .cornerRadius(25)
                        }
                    }
                )
            Text("\(item.articleType) - \(item.baseColor)")
                .font(.headline)
        }
        .onAppear{
            fetchClothImages{
                print("Success Clothes Images uploaded")
            }
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
