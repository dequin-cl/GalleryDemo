//
//  ImageListViewModelTests.swift
//  GalleryDemoTests
//
//  Created by Iván Galaz Jeria on 09-02-21.
//

import XCTest
@testable import GalleryDemo

class ImageListViewModelTests: XCTestCase {

  func testProcessCollection() throws {
    ///Given
    let bundle = Bundle(for: type(of: self))
    guard let jsonURL = bundle.url(forResource: "sample", withExtension: "json") else {
        XCTFail("Missing file: sample.json")
        return
    }

    let data = try Data(contentsOf: jsonURL)
    let collection = try Collection(data: data)
    
    var viewModel = ImageListViewModel()
    
    ///When
    viewModel.processAlbums(albums: collection)
    
    ///Then
    XCTAssertEqual(viewModel.numberOfSections, 1)
    XCTAssertEqual(viewModel.numberOfItemsInSection(0), 4)
    
    XCTAssertEqual(viewModel.imageAtIndex(0).thumbnailURL, "https://via.placeholder.com/150/92c952")
    XCTAssertEqual(viewModel.imageAtIndex(0).url, "https://via.placeholder.com/600/92c952")
    XCTAssertEqual(viewModel.imageAtIndex(0).identifier, "accusamus beatae ad facilis cum similique qui sunt")
  }

}
