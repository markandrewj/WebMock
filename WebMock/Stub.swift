//
//  Stub.swift
//  WebMock
//
//  Created by Wojtek on 19/04/2016.
//  Copyright © 2016 wojteklu. All rights reserved.
//

public enum HTTPMethod: String {
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
    case OPTIONS
    case HEAD
}

public struct Stub {
    let method: HTTPMethod?
    let URL: NSURL
    let response: Response
    
    public init(URL: NSURL, response: Response) {
        self.URL = URL
        self.response = response
        self.method = nil
    }
    
    public init(method: HTTPMethod, URL: NSURL, response: Response) {
        self.method = method
        self.URL = URL
        self.response = response
    }
    
    func match(request: NSURLRequest) -> Bool {
        
        if let stubMethod = method,
            requestMethod = HTTPMethod(rawValue: request.HTTPMethod ?? "")
            where stubMethod != requestMethod {
            return false
        }
        
        if let url = request.URL where url != self.URL {
            return false
        }
        
        return true
    }
}
