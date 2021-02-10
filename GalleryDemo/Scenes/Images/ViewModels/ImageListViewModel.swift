//
//  ImagesListViewModel.swift
//  GalleryDemo
//
//  Created by Iván Galaz Jeria on 08-02-21.
//

import Foundation

/// Model associated with the View that will display the Collection
struct ImageListViewModel {
  private var imageViewModels = [ImageViewModel]()
  private var identifierList = [String]()
  
  /// Recieves a potential new model to add to the list of objects to display on the Collection
  /// It validates that the object hasn't been added previously
  /// - Parameter vm: a new object to be display on the Collection
  mutating func addImageViewModel(_ vm: ImageViewModel) {
    if !identifierList.contains(vm.identifier) {
      self.imageViewModels.append(vm)
      identifierList.append(vm.identifier)
    }
  }
  
  /// Process a collection of albums, adding them to list of models
  /// - Parameter albums: List of albums parsed from the API
  mutating func processAlbums(albums: Collection) {
    for album in albums.albums {
      addImageViewModel(ImageViewModel(album))
    }
  }
}

extension ImageListViewModel {
  var numberOfSections: Int {
    return 1
  }

  func numberOfItemsInSection(_ section: Int) -> Int {
    return imageViewModels.count
  }

  func imageAtIndex(_ index: Int) -> ImageViewModel {
    return imageViewModels[index]
  }
}

/// Model associated with one instance to be displayed on the Collection
struct ImageViewModel {
  let url: String
  let thumbnailURL: String
  let identifier: String
}

extension ImageViewModel {
  init(_ album: Album) {
    self.url = album.url
    self.thumbnailURL = album.thumbnailURL
    self.identifier = album.title
  }
}
