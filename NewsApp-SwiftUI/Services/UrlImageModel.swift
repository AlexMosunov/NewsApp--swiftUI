//
//  UrlImageModel.swift
//  NewsApp-SwiftUI
//
//  Created by User on 13.09.2022.
//
import UIKit

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    @Published var errorMessage: String?
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
            errorMessage = "Was not able to load image from the url"
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

        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:)) //TODO: App Transport Security has blocked a cleartext HTTP connection tominfin.com.uasince it is insecure. Use HTTPS instead or add this domain to Exception Domains in your Info.plist.
        task.resume()
    }

    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            errorMessage = error.localizedDescription // TODO: Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
            print("Error: \(error)")
            return
        }
        guard let data = data else {
            return
        }

        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data),
                  let urlString = self.url?.absoluteString else {
                self.errorMessage = "Unable to load image from data"
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
