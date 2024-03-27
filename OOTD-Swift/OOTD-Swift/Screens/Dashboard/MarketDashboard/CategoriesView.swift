import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct ClothingElements: Identifiable {
    var id: String
    var subCategory: String
    var articleType: String
    var baseColor: String
    var displayName: String
}
struct CategoriesView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var showPopUp = false
    @State private var numbersIndex = 4
    @State private var selectedCategory: String?
    @State private var numbers: [Int] = [
        1163, 1164, 1165, 1525, 1526, 1528, 1529, 1530, 1531, 1532, 1533, 1534, 1535, 1536, 1537, 1538, 1539, 1540, 1541, 1542, 1543, 1544]
    
    //1545, 1546, 1547, 1548, 1549, 1550, 1551, 1552, 1553, 1554, 1555, 1556, 1557, 1558, 1559, 1561, 1562, 1563, 1565, 1566, 1567, 1569, 1570, 1571, 1572, 1573, 1575, 1577, 1578, 1579, 1580, 1581, 1582, 1583, 1584, 1587, 1588, 1590, 1591, 1592, 1594, 1595, 1596, 1597, 1598, 1599, 1603, 1604, 1605, 1607, 1608, 1609, 1610, 1611, 1612, 1613, 1614, 1615, 1616, 1617, 1618, 1619, 1620, 1621, 1622, 1623, 1624, 1625, 1626, 1627, 1628, 1634, 1635, 1636, 1637, 1638, 1641, 1642, 1644, 1645, 1646, 1647, 1648, 1649, 1651, 1653, 1654, 1656, 1657, 1658, 1662, 1668, 1670, 1671, 1673, 1678, 1689, 1697, 1727, 1728, 1729, 1730, 1731, 1752, 1754, 1755, 1756, 1757, 1758, 1759, 1760, 1762, 1763, 1764, 1765, 1766, 1782, 1783, 1784, 1785, 1786, 1787, 1788, 1789, 1790, 1791, 1792, 1793, 1794, 1795, 1796, 1798, 1799, 1800, 1801, 1802, 1803, 1804, 1805, 1806, 1807, 1808, 1809, 1810, 1811, 1812, 1813, 1814, 1827, 1828, 1831, 1832, 1833, 1836, 1841, 1842, 1844, 1845, 1846, 1847, 1848, 1849, 1852, 1853, 1854, 1855, 1856, 1857, 1859, 1860, 1861, 1862, 1863, 1865, 1866, 1867, 1868, 1869, 1870, 1871, 1872, 1875, 1876, 1877, 1879, 1880, 1881, 1882, 1883, 1884, 1885, 1886, 1887, 1888, 1889, 1890, 1891, 1892, 1895, 1897, 1902, 1903, 1904, 1905, 1906, 1907, 1909, 1910, 1911, 1912, 1913, 1915, 1916, 1917, 1918, 1919, 1920, 1922, 1923, 1924, 1925, 1926, 1927, 1928, 1929, 1930, 1931, 1932, 1933, 1934, 1935, 1936, 1937, 1938, 1939, 1941, 1942, 1943, 1944, 1945, 1946, 1947, 1948, 1949, 1950, 1951, 1962, 1963, 1964, 1966, 1972, 1973, 1976, 1977, 1978, 1981, 1982, 1983, 1984, 1985, 1986, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2014, 2015, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030, 2031, 2032, 2033, 2034, 2035, 2036, 2037, 2038, 2039, 2040, 2041, 2042, 2044, 2045, 2046, 2047, 2048, 2049, 2050, 2051, 2052, 2053, 2054, 2055, 2056, 2057, 2058, 2059, 2060, 2061, 2062, 2065, 2069, 2078, 2089, 2090, 2091, 2092, 2093, 2094, 2095, 2096, 2097, 2098, 2099, 2100, 2101, 2102, 2103, 2104, 2105, 2106, 2107, 2108, 2109, 2110, 2111, 2112]
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    let categories = ["Shirts", "Jackets", "Shoes", "Pants", "Hats"]
    
    let initialClothingItems: [ClothingElements] = [
        ClothingElements(id: "1163", subCategory: "Topwear", articleType: "T-Shirt", baseColor: "Blue", displayName: "Nike Sahara Team India Fanwear Round Neck Jersey"),
        ClothingElements(id: "1164", subCategory: "Topwear", articleType: "Tshirts", baseColor: "Blue", displayName: "Nike Men Blue T20 Indian Cricket Jersey"),
        ClothingElements(id: "1165", subCategory: "Topwear", articleType: "Tshirts", baseColor: "Blue", displayName: "Nike Mean Team India Cricket Jersey"),
        ClothingElements(id: "1525", subCategory: "Bags", articleType: "Backpacks", baseColor: "Navy", displayName: "Puma Deck Navy Blue Backpack")
    ]
    @State private var clothingItems: [ClothingElements] = []
    @State private var itemsToLoad = 4
    
    private func loadMoreItems() {
        let endIndex = min(numbers.count, numbersIndex + itemsToLoad)
        let idsToLoad = numbers[numbersIndex..<endIndex]
        
        for id in idsToLoad {
            let clothingItem = ClothingElements(id: "\(id)", subCategory: "", articleType: "", baseColor: "", displayName: "")
            clothingItems.append(clothingItem)
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
                    ForEach(clothingItems, id: \.id) { item in
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
            Text(item.articleType)
                .font(.headline)
            
            Text(item.baseColor)
                .font(.subheadline)
                .foregroundColor(.gray)
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
