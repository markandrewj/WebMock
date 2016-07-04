//
//  NSURLSessionConfiguration.swift
//  WebMock
//
//  Created by Wojtek on 20/04/2016.
//  Copyright © 2016 wojteklu. All rights reserved.
//

import Foundation

public extension NSURLSessionConfiguration {

    public class func webmockDefaultSessionConfiguration() -> NSURLSessionConfiguration {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.protocolClasses = [WebMockProtocol.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }
    
    public class func webmockEphemeralSessionConfiguration() -> NSURLSessionConfiguration {
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        configuration.protocolClasses = [WebMockProtocol.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }
}
