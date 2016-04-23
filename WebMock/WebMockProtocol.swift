//
//  WebMockProtocol.swift
//  WebMock
//
//  Created by Wojtek on 19/04/2016.
//  Copyright © 2016 wojteklu. All rights reserved.
//

class WebMockProtocol: NSURLProtocol {
    
    static func startWithStubs(stubs: [Stub]) {
        
        NSURLSessionConfiguration.swizzleSessionConfiguration()
                
        self.stubs = stubs
    }
    
    static func removeAllStubs() {
        self.stubs = []
    }
    
    private static var stubs: [Stub] = []

    private enum PropertyKeys {
        static let HandledByProxyURLProtocol = "HandledByProxyURLProtocol"
    }
    
    private lazy var session: NSURLSession = {
        let configuration: NSURLSessionConfiguration = {
            let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            return configuration
        }()
        
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        return session
    }()
    private var activeTask: NSURLSessionTask?
    
    override internal class func canInitWithRequest(request: NSURLRequest) -> Bool {
        if NSURLProtocol.propertyForKey(PropertyKeys.HandledByProxyURLProtocol, inRequest: request) != nil {
            return false
        }
        
        return true
    }
    
    override internal class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
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
    
    override internal func startLoading() {
        
        if let stub = WebMockProtocol.stubs.find({$0.match(request)}) {
            startLoadingStub(stub)
            return
        }
        
        let mutableRequest = NSMutableURLRequest(URL: request.URL!)
        NSURLProtocol.setProperty(true, forKey: PropertyKeys.HandledByProxyURLProtocol, inRequest: mutableRequest)
        
        activeTask = session.dataTaskWithRequest(mutableRequest)
        activeTask?.resume()
    }
    
    override internal func stopLoading() {
        activeTask?.cancel()
    }
}

extension WebMockProtocol: NSURLSessionDelegate {
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        client?.URLProtocol(self, didLoadData: data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let response = task.response {
            client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
        }
        
        client?.URLProtocolDidFinishLoading(self)
    }
}
