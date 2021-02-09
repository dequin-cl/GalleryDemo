//
//  AlbumsTests.swift
//  GalleryDemoTests
//
//  Created by Iván Galaz Jeria on 06-02-21.
//

import XCTest
@testable import GalleryDemo

class CollectionTests: XCTestCase {

    func testExample() throws {
      let bundle = Bundle(for: type(of: self))
      guard let jsonURL = bundle.url(forResource: "sample", withExtension: "json") else {
          XCTFail("Missing file: sample.json")
          return
      }

      let data = try Data(contentsOf: jsonURL)
      
      let collection = try Collection(data: data)
      
      XCTAssertNotNil(collection)
      
      XCTAssertEqual(collection[2].title, "officia porro iure quia iusto qui ipsa ut modi")
    }

}
