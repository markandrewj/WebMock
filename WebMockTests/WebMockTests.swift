//
//  WebMockTests.swift
//  WebMockTests
//
//  Created by Wojtek on 21/04/2016.
//  Copyright © 2016 wojteklu. All rights reserved.
//

import XCTest
@testable import WebMock

class WebMockTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        WebMock.removeAllStubs()
    }
    
    func testStubbedRequestUsingDefaultSessionConfiguration() {
        
        let expectation = expectationWithDescription(#function)

        testStubbedRequest(expectation, usingEphemeralSessionConfiguration: false)
    }
    
    func testStubbedRequestUsingEphemeralSessionConfiguration() {
        
        let expectation = expectationWithDescription(#function)
        
        testStubbedRequest(expectation, usingEphemeralSessionConfiguration: true)
    }
    
    func testStubbedFailureRequest() {
        
        let expectation = expectationWithDescription(#function)
        
        // stub request
        let responseError = NSError(domain: NSInternalInconsistencyException,
                                         code: 0,
                                         userInfo: nil)
        let response = Response(error: responseError)
        let URL = NSURL(string: "https://www.google.com")!
        let stub = Stub(URL: URL, response: response)
        
        WebMock.startWithStub(stub)
        
        // test request response
        self.fetch(URL, completion: { (data, response, error) in
            
            XCTAssertEqual(responseError, error)
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            XCTAssertNil(error)
        }
    }
    
    func testNotStubbedRequest() {
        
        WebMockProtocol.removeAllStubs()
        
        let expectation = expectationWithDescription(#function)
        let URL = NSURL(string: "https://www.google.com")!
        
        // test request response
        self.fetch(URL, completion: { (data, response, error) in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            XCTAssertNil(error)
        }
    }
    
    func testStubbedRequest(expectation: XCTestExpectation,
                                    usingEphemeralSessionConfiguration: Bool) {
        
        // stub request
        let json = ["testKey": "testValue"]
        let response = Response(json: json)
        let URL = NSURL(string: "https://www.google.com")!
        let stub = Stub(URL: URL, response: response)
        
        WebMock.startWithStubs([stub])
        
        // test request response
        self.fetch(URL, usingEphemeralSessionConfiguration: usingEphemeralSessionConfiguration,
                   completion: { (data, response, error) in
            
            let expectedJson = try! NSJSONSerialization.JSONObjectWithData(data!,
                options: NSJSONReadingOptions()) as! [String: String]
            XCTAssertEqual(json, expectedJson)
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            XCTAssertNil(error)
        }
    }
    
    private func fetch(URL: NSURL, usingEphemeralSessionConfiguration: Bool = false,
                       completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        var configuration: NSURLSessionConfiguration = .webmockDefaultSessionConfiguration()
        
        if usingEphemeralSessionConfiguration {
            configuration = .webmockEphemeralSessionConfiguration()
        }
        
        let session = NSURLSession(configuration: configuration)
        
        session.dataTaskWithURL(URL) { data, response, error in
            dispatch_async(dispatch_get_main_queue()) {
                completion(data, response, error)
            }
            }.resume()
    }
}
