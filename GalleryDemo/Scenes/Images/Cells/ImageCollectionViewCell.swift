//
//  ImageCollectionViewCell.swift
//  GalleryDemo
//
//  Created by Iván Galaz Jeria on 08-02-21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
  static let identifier = "ImageCollectionViewCell"

  var imageView = UIImageView()
  private(set) var imageIdentifier: String?

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.clipsToBounds = true
    self.autoresizesSubviews = true

    imageView.frame = self.bounds
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(imageView)

    // Use a random background color.
    let redColor = CGFloat(arc4random_uniform(255)) / 255.0
    let greenColor = CGFloat(arc4random_uniform(255)) / 255.0
    let blueColor = CGFloat(arc4random_uniform(255)) / 255.0
    self.backgroundColor = UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1.0)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    imageIdentifier = nil
  }

  func configure(vm: ImageViewModel) {
    imageIdentifier = vm.identifier
  }
}
