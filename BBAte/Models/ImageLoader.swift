//
//  ImageLoader.swift
//  BBAte
//
//  Created by Patrick Hughes on 8/29/20.
//  Copyright © 2020 Fluffy Bunny Software. All rights reserved.
//

import UIKit

class ImageLoader: NSObject {
    static var shared = ImageLoader()
    private var cache = NSCache<NSURL, UIImage>()
    private let session = URLSession(configuration: URLSessionConfiguration.default)

    func loadImageForUrl(_ url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionTask? {
        let nsUrl = url as NSURL
        if let image = self.cache.object(forKey: nsUrl) {
            completion(image)
            return nil
        }

        let task = self.session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: nsUrl)
                completion(image)
            }
            else {
                completion(nil)
            }
        }

        task.resume()
        return task
    }
}

extension UIImageView {
    func setImage(with url: URL?) {
        if let task = self.task {
            task.cancel()
            self.task = nil
        }

        self.image = nil
        if let url = url {
            self.task = ImageLoader.shared.loadImageForUrl(url) { image in
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }

    static var AssociatedObjectHandle: UInt8 = 0
    private var task: URLSessionTask? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.AssociatedObjectHandle) as? URLSessionTask
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.AssociatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

}
