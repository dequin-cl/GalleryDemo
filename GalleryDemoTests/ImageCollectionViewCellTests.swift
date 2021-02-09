//
//  ImageCollectionViewCellTests.swift
//  GalleryDemoTests
//
//  Created by Iván Galaz Jeria on 09-02-21.
//

import XCTest
@testable import GalleryDemo

class ImageCollectionViewCellTests: XCTestCase {

  func testCreationCell() {
    /// Given
    let rect = CGRect(origin: .zero, size: CGSize(width: 300, height: 100))
    let identifier = "identifier"
    /// When
    let cell = ImageCollectionViewCell(frame: rect)

    cell.configure(vm: ImageViewModel(Album(albumID: 0, id: 0, title: identifier, url: "test", thumbnailURL: "test")))

    /// Then
    XCTAssertEqual(cell.imageIdentifier, identifier)
    XCTAssertTrue(cell.subviews.contains(cell.imageView))
    XCTAssertEqual(cell.imageView.frame, rect)
    XCTAssertNotEqual(cell.backgroundColor, UIColor.black)
  }

  func testPrepareForReuseCell() {
    /// Given
    let rect = CGRect(origin: .zero, size: CGSize(width: 300, height: 100))
    let cell = ImageCollectionViewCell(frame: rect)
    let image = UIImage()
    cell.imageView.image = image
    /// When
    cell.prepareForReuse()
    /// Then
    XCTAssertNil(cell.imageView.image)
    XCTAssertNil(cell.imageIdentifier)
  }
}
