//
//  ImageDetailViewController.swift
//  GalleryDemo
//
//  Created by Iván Galaz Jeria on 09-02-21.
//

import UIKit

class ImageDetailViewController: UIViewController {

  private var imageView = UIImageView()
  private var progressBar = UIProgressView()
  private var observation: NSKeyValueObservation?
  var imageURL: String? {
    didSet {
      processImageURL()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    imageView.frame = view.bounds
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    imageView.image = UIImage.withColor(.white, size: imageView.frame.size)

    view.addSubview(imageView)

    progressBar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(progressBar)

    progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    progressBar.heightAnchor.constraint(equalToConstant: 2).isActive = true

    progressBar.progress = 0.0
  }

  private func processImageURL() {
    guard let imageURL = imageURL else { return }

    let url = URL(string: imageURL)!
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in

      if let error = error {
        print(error.localizedDescription)
      } else if let data = data {
        DispatchQueue.main.async {
          self?.imageView.image = UIImage(data: data)
        }
      }
    }
    observation = task.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
      self?.updateProgress(progress: progress.fractionCompleted)
    }
    task.resume()
  }

  private func updateProgress(progress: Double) {
    DispatchQueue.main.async {

      self.progressBar.progress = Float(progress)
      if self.progressBar.progress == 1.0 {
        self.progressBar.isHidden = true
      }
    }

  }

  deinit {
    observation?.invalidate()
  }
}

#if DEBUG
import SwiftUI

struct ImageDetailVCRepresentable: UIViewControllerRepresentable {
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    // leave this empty
  }

  @available(iOS 13.0.0, *)
  func makeUIViewController(context: Context) -> UIViewController {
    ImageDetailViewController()
  }
}

@available(iOS 13.0, *)
struct InfoVCPreview: PreviewProvider {
  static var previews: some View {
    ImageDetailVCRepresentable()
  }
}
#endif

extension UIImage {
  static func withColor(_ color: UIColor, size: CGSize) -> UIImage {
    var capturedImage: UIImage!

    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    if let context = UIGraphicsGetCurrentContext() {
      context.setFillColor(color.cgColor)
      context.fill(CGRect(origin: .zero, size: size))
      capturedImage = UIGraphicsGetImageFromCurrentImageContext()!
    }
    UIGraphicsEndImageContext()
    return capturedImage
  }
}
