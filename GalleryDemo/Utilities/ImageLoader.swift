//
//  ImageLoader.swift
//  GalleryDemo
//
//  Created by Iván Galaz Jeria on 08-02-21.
//

import UIKit

final class ImageLoader {
  
  var task: URLSessionDownloadTask!
  var session: URLSession!
  var cache: NSCache<NSString, UIImage>!
  
  init() {
    session = URLSession.shared
    task = URLSessionDownloadTask()
    self.cache = NSCache()
  }
  
  func obtainImageWithPath(imagePath: String, vm: ImageViewModel, completionHandler: @escaping (UIImage, ImageViewModel) -> ()) {
    if let image = self.cache.object(forKey: imagePath as NSString) {
      DispatchQueue.main.async {
        completionHandler(image, vm)
      }
    } else {
//      let placeholder = #imageLiteral(resourceName: "placeholder")
//      DispatchQueue.main.async {
//        completionHandler(placeholder)
//      }
      let url: URL! = URL(string: imagePath)
      task = session.downloadTask(with: url, completionHandler: { (location, response, error) in
        if let data = try? Data(contentsOf: url) {
          let image: UIImage! = UIImage(data: data)
          self.cache.setObject(image, forKey: imagePath as NSString)
          DispatchQueue.main.async {
            completionHandler(image, vm)
          }
        }
      })
      task.resume()
    }
  }
}
