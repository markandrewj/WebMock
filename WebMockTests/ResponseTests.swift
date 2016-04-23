//
//  ResponseTests.swift
//  WebMock
//
//  Created by Wojtek on 21/04/2016.
//  Copyright © 2016 wojteklu. All rights reserved.
//

import XCTest
@testable import WebMock

class ResponseTests: XCTestCase {

    func testResponseWithFailure() {
        
        let error = NSError(domain: NSInternalInconsistencyException,
                            code: 0,
                            userInfo: nil)
        
        let expectedResult: Result = .Failure(error)
        
        let response = Response(error: error)
        
        XCTAssertEqual(response.result, expectedResult)
    }
    
    func testResponseWithJson() {
        let json = ["testKey": "testValue"]
        let data = try? NSJSONSerialization.dataWithJSONObject(json,
                                                               options: NSJSONWritingOptions())
        let response = Response(statusCode: 200,
                                headerFields: [:],
                                json: json)
        
        let expectedResult: Result = .Success(statusCode: 200,
                                              headerFields: [:],
                                               response: data)
        
        XCTAssertEqual(response.result, expectedResult)
    }
    
    func testResponseWithData() {
        let data = "test".dataUsingEncoding(NSUTF8StringEncoding)
        
        let response = Response(statusCode: 200,
                                headerFields: [:],
                                data: data)
        
        let expectedResult: Result = .Success(statusCode: 200,
                                              headerFields: [:],
                                              response: data)
        
        XCTAssertEqual(response.result, expectedResult)
    }
    
    func testResponseFromFile() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let fileURL = bundle.pathForResource("test", ofType: "json")!
        let data = try? NSData(contentsOfFile: fileURL, options: NSDataReadingOptions())
        let response = Response(fileURL: fileURL)
        
        let expectedResult: Result = .Success(statusCode: 200,
                                              headerFields: [:],
                                              response: data)
        
        XCTAssertEqual(response.result, expectedResult)
    }
    
    
}