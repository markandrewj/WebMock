//
//  WebMock.swift
//  WebMock
//
//  Created by Wojtek on 15/04/2016.
//  Copyright © 2016 wojteklu. All rights reserved.
//

import Foundation


public class WebMock {
    
    public static func startWithStub(stub: Stub) {
        WebMockProtocol.startWithStubs([stub])
    }
    public static func startWithStubs(stubs: [Stub]) {
        WebMockProtocol.startWithStubs(stubs)
    }
 
    public static func removeAllStubs() {
        WebMockProtocol.removeAllStubs()
    }
}
