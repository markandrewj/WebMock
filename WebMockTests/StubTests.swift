//
//  StubTests.swift
//  WebMock
//
//  Created by Wojtek on 21/04/2016.
//  Copyright © 2016 wojteklu. All rights reserved.
//

import XCTest
@testable import WebMock

class StubTests: XCTestCase {

    func testStubMatchingRequest() {
        
        let URL = NSURL(string: "https://www.google.com")!
        let response = Response()
        let stub = Stub(method: .GET, URL: URL,
                         response: response)
        
        // NSURLRequest default http method is .GET
        let request = NSURLRequest(URL: URL)
        
        XCTAssertTrue(stub.match(request))
    }
    
    func testStubNotMatchingRequestURL() {
        
        let URL = NSURL(string: "https://www.google.com")!
        let response = Response()
        let stub = Stub(URL: URL,
                        response: response)
        
        let URL2 = NSURL(string: "https://www.bing.com")!
        let request = NSURLRequest(URL: URL2)
        
        XCTAssertFalse(stub.match(request))
    }
    
    func testStubNotMatchingRequestHTTPMethod() {
        
        let URL = NSURL(string: "https://www.google.com")!
        let response = Response()
        let stub = Stub(method: .PUT, URL: URL,
                        response: response)
        
        // NSURLRequest default http method is .GET
        let request = NSURLRequest(URL: URL)
        
        XCTAssertFalse(stub.match(request))
    }

}