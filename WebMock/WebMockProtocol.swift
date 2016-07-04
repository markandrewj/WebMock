//
//  WebMockProtocol.swift
//  WebMock
//
//  Created by Wojtek on 19/04/2016.
//  Copyright © 2016 wojteklu. All rights reserved.
//

internal class WebMockProtocol: NSURLProtocol {
    
    private static var stubs: [Stub] = []

    static func startWithStubs(stubs: [Stub]) {
        WebMockProtocol.stubs = stubs
    }
    
    static func removeAllStubs() {
        WebMockProtocol.stubs = []
    }
    
    override internal func startLoading() {
        
        if let stub = WebMockProtocol.stubs.find({$0.match(request)}) {
            startLoadingStub(stub)
            return
        }
        
        let error = NSError(domain: NSInternalInconsistencyException,
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Handling request without a matching stub."])
        client?.URLProtocol(self, didFailWithError: error)
    }
    
    override internal class func canInitWithRequest(request:NSURLRequest) -> Bool {
        return WebMockProtocol.stubs.find({$0.match(request)}) != nil
    }
    
    override internal class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override internal func stopLoading() {}
    
    private func startLoadingStub(stub: Stub) {
        
        switch stub.response.result {
        case .Failure(let error):
            client?.URLProtocol(self, didFailWithError: error)
        case .Success(let statusCode, let headerFields, let data):
            
            if let URL = request.URL,
                response = NSHTTPURLResponse(URL: URL,
                                                statusCode: statusCode,
                                                HTTPVersion: nil,
                                                headerFields: headerFields) {
                
                client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
                
                if let data = data {
                    client?.URLProtocol(self, didLoadData: data)
                }
                
                client?.URLProtocolDidFinishLoading(self)
            } else {
                let error = NSError(domain: NSInternalInconsistencyException,
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Failed to construct response for stub."])
                client?.URLProtocol(self, didFailWithError: error)
            }
        }
    }
    
}
