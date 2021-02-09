//
//  Albums.swift
//  GalleryDemo
//
//  Created by Iván Galaz Jeria on 06-02-21.
//

import Foundation

struct Album: Decodable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

struct Collection: Decodable {
  private (set) var albums: [Album]
  
  init(data: Data) throws {
      albums = try JSONDecoder().decode(Array<Album>.self, from: data)
  }
  
  subscript(index: Int) -> Album {
    return albums[index]
  }
}
