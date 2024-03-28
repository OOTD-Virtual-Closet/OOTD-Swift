//
//  ImageLoader.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/29/24.
//

import UIKit

// Define a subclass of NSCache that holds UIImage objects but wraps them in ImageCache objects
class ImageCache: NSCache<NSURL, ImageCacheWrapper> {
    // Your cache initialization and configuration if needed
}

// Define your ImageCacheWrapper that conforms to NSDiscardableContent
class ImageCacheWrapper: NSObject, NSDiscardableContent {
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func beginContentAccess() -> Bool {
        return true
    }
    
    func endContentAccess() {
        
    }
    
    func discardContentIfPossible() {
        
    }
    
    func isContentDiscarded() -> Bool {
        return false
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let cache = ImageCache()
    
    func loadImage(from url: URL) {
        let nsURL = url as NSURL
        
        if let cachedWrapper = cache.object(forKey: nsURL) {
            self.image = cachedWrapper.image
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil, let downloadedImage = UIImage(data: data) else { return }
            
            let wrapper = ImageCacheWrapper(image: downloadedImage)
            self.cache.setObject(wrapper, forKey: nsURL)
            
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}

//import SwiftUI
//import Combine
//import UIKit
//
//class ImageLoader: ObservableObject {
//    @Published var image: UIImage?
//    private var cache: NSCache<NSURL, UIImage> = NSCache()
//
//    func loadImage(from url: URL) {
//        if let cachedImage = cache.object(forKey: url as NSURL) {
//            DispatchQueue.main.async {
//                self.image = cachedImage
//            }
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//            guard let data = data, error == nil, let downloadedImage = UIImage(data: data) else { return }
//            self?.cache.setObject(downloadedImage, forKey: url as NSURL) //caches image
//
//            DispatchQueue.main.async {
//                self?.image = downloadedImage
//            }
//        }.resume()
//    }
//}
