//
//  ImageListCollectionViewController.swift
//  GalleryDemo
//
//  Created by Iván Galaz Jeria on 08-02-21.
//

import UIKit

class ImageListCollectionViewController: UIViewController {
  
  private var collectionView: UICollectionView!
  private var imageListVM = ImageListViewModel()
  private var imageLoader = ImageLoader()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
    
    // Register cell classes
    let mosaicLayout = MosaicLayout()
    collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: mosaicLayout)
    collectionView.backgroundColor = UIColor.appBackgroundColor
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.alwaysBounceVertical = true
    collectionView.indicatorStyle = .white
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(ImageCollectionViewCell.self,
                            forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    
    self.view.addSubview(collectionView)
    
    // Do any additional setup after loading the view.
  }
  
  private func setup() {
    Webservice.load { [weak self] albums in
      if let collection = albums {
        self?.imageListVM.processAlbums(albums: collection)
        
        DispatchQueue.main.async {
          self?.collectionView.reloadData()
        }
      }
    }
  }
}

extension ImageListCollectionViewController: UICollectionViewDataSource {
  // MARK: UICollectionViewDataSource
  
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    
    return imageListVM.numberOfSections
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return imageListVM.numberOfItemsInSection(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
      fatalError("Could not dequeue an ImageCollectionViewCell")
    }
    
    // Configure the cell
    let imageVM = imageListVM.imageAtIndex(indexPath.item)
    cell.configure(vm: imageVM)

    imageLoader.obtainImageWithPath(imagePath: imageVM.thumbnailURL, vm: imageVM) { (image, vm) in
      
      if cell.imageIdentifier == vm.identifier {
        cell.imageView.image = image
      }
    }
    
    return cell
  }
  
}

extension ImageListCollectionViewController: UICollectionViewDelegate {
  // MARK: UICollectionViewDelegate
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let imageVM = imageListVM.imageAtIndex(indexPath.item)

    let imageDetailVC = ImageDetailViewController()
    imageDetailVC.imageURL = imageVM.url
    self.navigationController?.pushViewController(imageDetailVC, animated: true)
  }
}
