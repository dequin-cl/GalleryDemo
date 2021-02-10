//
//  Image.swift
//  GalleryDemo
//
//  Created by Iván Galaz Jeria on 10-02-21.
//

import UIKit

extension UIImage {
  
  /// Create a new Image with color and size
  /// - Parameters:
  ///   - color: color to apply to the image
  ///   - size: size that the image have to have
  /// - Returns: a new image
  static func withColor(_ color: UIColor, size: CGSize) -> UIImage {
    var capturedImage: UIImage?

    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    if let context = UIGraphicsGetCurrentContext() {
      context.setFillColor(color.cgColor)
      context.fill(CGRect(origin: .zero, size: size))
      capturedImage = UIGraphicsGetImageFromCurrentImageContext()
    }
    UIGraphicsEndImageContext()
    return capturedImage ?? UIImage()
  }
}
