//
//  ImageDetailViewController.swift
//  GalleryDemo
//
//  Created by Iván Galaz Jeria on 09-02-21.
//

import UIKit

/// Shows an image Full Screen
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

    configureMainImageView()

    configureProgressBar()
  }
  
  /// Configure and adds to the hierarchy the ImageView that will display the required image
  private func configureMainImageView() {
    imageView.frame = view.bounds
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    imageView.image = UIImage.withColor(.white, size: imageView.frame.size)
    
    view.addSubview(imageView)
  }
  
  /// Configure and adds to the hierarchy the progress bar used to give feedback to the user that something is happening while downloading the required image
  private func configureProgressBar() {
    progressBar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(progressBar)
    
    progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    progressBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
    
    progressBar.progress = 0.0
  }
  
  /// Once the required image has been set to the VC, this method will create a dataTask to grab the image from the network
  /// Will configure the progress observer to update the Progress Bar
  /// At the end of the network process, will update the contents of the UIImageView
  private func processImageURL() {
    guard let imageURL = imageURL,
          let url = URL(string: imageURL) else { return }

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
  
  /// Refresh the progress on the Progress Bar
  /// - Parameter progress: the current progress to show
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

/// Used for developing. You have an immediate preview of the ViewController
/// If neccesary you could insert data for a more accurate visualization

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
