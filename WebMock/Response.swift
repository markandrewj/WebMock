//
//  Response.swift
//  WebMock
//
//  Created by Wojtek on 19/04/2016.
//  Copyright © 2016 wojteklu. All rights reserved.
//

enum Result {
    case Success(statusCode: Int, headerFields: [String: String], response: NSData?)
    case Failure(NSError)
}

extension Result: Equatable {}

func ==(lhs: Result, rhs: Result) -> Bool {
    switch (lhs, rhs) {
    case let (.Success(lhsStatusCode, lhsHeaderFields, lhsResponse),
        .Success(rhsStatusCode, rhsHeaderFields, rhsResponse)):
        
        return lhsStatusCode == rhsStatusCode && lhsHeaderFields == rhsHeaderFields
            && lhsResponse == rhsResponse
    case let (.Failure(lhsError), .Failure(rhsError)):
        return lhsError == rhsError
    default:
        return false
    }
}

public struct Response {
    
    var result: Result
    
    public init(error: NSError) {
        result = .Failure(error)
    }
    
    public init(statusCode: Int = 200, headerFields: [String:String] = [:], data: NSData? = nil) {
        result = .Success(statusCode: statusCode, headerFields: headerFields, response: data)
    }
    
    public init(statusCode: Int = 200, headerFields: [String:String] = [:], json: AnyObject) {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(json,
                                                                  options: NSJSONWritingOptions())
            
            result = .Success(statusCode: statusCode,
                              headerFields: headerFields,
                              response: data)
        } catch {
            result = .Failure(error as NSError)
        }
    }
    
    public init(statusCode: Int = 200, headerFields: [String:String] = [:], fileURL: String) {
        
        do {
            let data = try NSData(contentsOfFile: fileURL, options: NSDataReadingOptions())
            
            result = .Success(statusCode: statusCode,
                              headerFields: headerFields,
                              response: data)
        } catch {
            result = .Failure(error as NSError)
        }
    }
}
