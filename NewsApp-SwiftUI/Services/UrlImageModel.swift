//
//  UrlImageModel.swift
//  NewsApp-SwiftUI
//
//  Created by User on 13.09.2022.
//
import UIKit

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var url: URL?
    var imageCache = ImageCache.getImageCache()
    
    init(url: URL?) {
        self.url = url
        loadImage()
    }
    
    func loadImage() {
        if loadImageFromCache() {
            return
        }
        loadImageFromUrl()
    }
    
    func loadImageFromCache() -> Bool {
        guard let url = url else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: url.absoluteString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    
    func loadImageFromUrl() {
        guard let url = url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data),
                  let urlString = self.url?.absoluteString else {
                return
            }

            self.imageCache.set(forKey: urlString, image: loadedImage)
            self.image = loadedImage
        }
    }
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}