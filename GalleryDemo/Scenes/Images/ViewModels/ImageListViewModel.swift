//
//  ImagesListViewModel.swift
//  GalleryDemo
//
//  Created by Iván Galaz Jeria on 08-02-21.
//

import Foundation

struct ImageListViewModel {
  private var imageViewModels = [ImageViewModel]()
  
  mutating func addImageViewModel(_ vm: ImageViewModel) {
    self.imageViewModels.append(vm)
  }
  
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
