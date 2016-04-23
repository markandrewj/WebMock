//
//  NSURLSessionConfiguration.swift
//  WebMock
//
//  Created by Wojtek on 20/04/2016.
//  Copyright © 2016 wojteklu. All rights reserved.
//

import Foundation


var token: dispatch_once_t = 0

extension NSURLSessionConfiguration {

    class func webmockDefaultSessionConfiguration() -> NSURLSessionConfiguration {
        let configuration = webmockDefaultSessionConfiguration()
        configuration.protocolClasses = [WebMockProtocol.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }
    
    class func webmockEphemeralSessionConfiguration() -> NSURLSessionConfiguration {
        let configuration = webmockEphemeralSessionConfiguration()
        configuration.protocolClasses = [WebMockProtocol.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }
    
    class func swizzleSessionConfiguration() {
        dispatch_once(&token) {
            let defaultSessionConfiguration = class_getClassMethod(self, #selector(NSURLSessionConfiguration.defaultSessionConfiguration))
            let webmockDefaultSessionConfiguration = class_getClassMethod(self, #selector(NSURLSessionConfiguration.webmockDefaultSessionConfiguration))
            method_exchangeImplementations(defaultSessionConfiguration, webmockDefaultSessionConfiguration)
            
            let ephemeralSessionConfiguration = class_getClassMethod(self, #selector(NSURLSessionConfiguration.ephemeralSessionConfiguration))
            let webmockEphemeralSessionConfiguration = class_getClassMethod(self, #selector(NSURLSessionConfiguration.webmockEphemeralSessionConfiguration))
            method_exchangeImplementations(ephemeralSessionConfiguration, webmockEphemeralSessionConfiguration)
        }
    }
}
