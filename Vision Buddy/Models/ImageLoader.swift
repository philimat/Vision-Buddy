//
//  ImageLoader.swift
//  Vision Buddy
//
//  Created by Matt Philippi on 3/9/21.
//

import SwiftUI
import Cocoa

private let _imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: ObservableObject {
    @Published var image: NSImage?
    @Published var isLoading = false
    @Published var imageURL: URL?

    var imageCache = _imageCache

    func loadImage(with url: URL) {
        let urlString = url.absoluteString
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? NSImage {
            self.image = imageFromCache
            return
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
//            do {
//                let data = try Data(contentsOf: url)
                let image = NSImage(byReferencing: url)
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                    self?.imageURL = url
                }
//
//            } catch {
//                print(error.localizedDescription)
//            }
        }
    }
}
