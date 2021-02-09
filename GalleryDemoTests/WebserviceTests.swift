//
//  WebserviceTests.swift
//  GalleryDemoTests
//
//  Created by Iván Galaz Jeria on 09-02-21.
//

import XCTest
@testable import GalleryDemo

class WebserviceTests: XCTestCase {

  func testLoadWithErrorCallsbackWithNil() {
    let response = HTTPURLResponse(url: API.albumsURL, statusCode: 200, httpVersion: nil, headerFields: nil)
    let error = NSError(domain: "Test", code: 001, userInfo: nil)
    URLProtocolMock.mockURLs = [API.albumsURL: (error, nil, response)]
    let sessionConfiguration = URLSessionConfiguration.ephemeral
    sessionConfiguration.protocolClasses = [URLProtocolMock.self]
    let mockSession = URLSession(configuration: sessionConfiguration)
    Webservice.urlSession = mockSession
    
    let albumsResource = Resource<Collection>(url: API.albumsURL) { data -> Collection? in
      return try? Collection(data: data)
    }

    let expectation = XCTestExpectation(description: "Fetching data")

    Webservice.load(resource: albumsResource) { result in
      XCTAssertNil(result)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)
  }
  
  func testLoadWithoutErrorNorDataCallsbackWithNil() {
    let response = HTTPURLResponse(url: API.albumsURL, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    URLProtocolMock.mockURLs = [API.albumsURL: (nil, nil, response)]
    let sessionConfiguration = URLSessionConfiguration.ephemeral
    sessionConfiguration.protocolClasses = [URLProtocolMock.self]
    let mockSession = URLSession(configuration: sessionConfiguration)
    Webservice.urlSession = mockSession
    
    let albumsResource = Resource<Collection>(url: API.albumsURL) { data -> Collection? in
      return try? Collection(data: data)
    }

    let expectation = XCTestExpectation(description: "Fetching data")

    Webservice.load(resource: albumsResource) { result in
      XCTAssertNil(result)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)
  }
  
  func testLoadWithErrorCallsbackWithObject() throws {
    let bundle = Bundle(for: type(of: self))
    guard let jsonURL = bundle.url(forResource: "sample", withExtension: "json") else {
        XCTFail("Missing file: sample.json")
        return
    }

    let data = try Data(contentsOf: jsonURL)
    let response = HTTPURLResponse(url: API.albumsURL, statusCode: 200, httpVersion: nil, headerFields: nil)
    URLProtocolMock.mockURLs = [API.albumsURL: (nil, data, response)]
    
    let sessionConfiguration = URLSessionConfiguration.ephemeral
    sessionConfiguration.protocolClasses = [URLProtocolMock.self]
    let mockSession = URLSession(configuration: sessionConfiguration)
    Webservice.urlSession = mockSession
    
    let albumsResource = Resource<Collection>(url: API.albumsURL) { data -> Collection? in
      return try? Collection(data: data)
    }
    let expectation = XCTestExpectation(description: "Fetching data")

    Webservice.load(resource: albumsResource) { result in
      XCTAssertNotNil(result)
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)
  }
}
