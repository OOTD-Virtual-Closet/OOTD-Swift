//
//  ImageLoader.swift
//  OOTD-Swift
//
//  Created by Aaryan Srivastava on 2/29/24.
//

import SwiftUI
import Combine
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cache: NSCache<NSURL, UIImage> = NSCache()

    func loadImage(from url: URL) {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil, let downloadedImage = UIImage(data: data) else { return }
            self?.cache.setObject(downloadedImage, forKey: url as NSURL) //caches image

            DispatchQueue.main.async {
                self?.image = downloadedImage
            }
        }.resume()
    }
}
