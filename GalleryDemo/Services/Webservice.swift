//
//  Webservice.swift
//  GoodWeather
//
//  Created by Iván Galaz Jeria on 08-02-21.
//

import Foundation

struct API {
  private init() {}

  static let albumsURL = URL(string: "https://jsonplaceholder.typicode.com/photos")!
}

struct Resource<T> {
  let url: URL
  let parse: (Data) -> T?
}

final class Webservice {
  static var urlSession: URLSession = URLSession.shared
  
  /// Generic function to load data from network
  /// - Parameters:
  ///   - resource: a Resource object that will manage the network data
  ///   - completion: if successful returns an object of the calling type
  static func load<T>(resource: Resource<T>, completion: @escaping (T?) -> Void) {
    urlSession.dataTask(with: resource.url) { data, _, error in

      if let error = error {
        print(error.localizedDescription)
        completion(nil)
      } else if let data = data {
        completion(resource.parse(data))
      } else {
        completion(nil)
      }

    }.resume()
  }
  
  /// Specific function to load Collection data from network
  /// - Parameters:
  ///   - completion: if successfull return a Collection of Albums
  static func load(url: URL = API.albumsURL, completion: @escaping (Collection?) -> Void) {
    let albumsResource = Resource<Collection>(url: url) { data -> Collection? in
      return try? Collection(data: data)
    }

    Webservice.load(resource: albumsResource) { result in
      if let result = result {
        completion(result)
      } else {
        completion(nil)
      }
    }

  }
}
