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
  
  /// Process a path to download an Image. If the image has not been download before, it adds the result to the cache.
  /// - Parameters:
  ///   - imagePath: from where to download the image
  ///   - vm: the relevant ViewModel
  ///   - completionHandler: will return the new Image and the ViewModel
  func obtainImageWithPath(imagePath: String, vm: ImageViewModel, completionHandler: @escaping (UIImage, ImageViewModel) -> Void) {
    if let image = self.cache.object(forKey: imagePath as NSString) {
      DispatchQueue.main.async {
        completionHandler(image, vm)
      }
    } else {

      let url: URL! = URL(string: imagePath)
      task = session.downloadTask(with: url, completionHandler: { (_, _, _) in
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
