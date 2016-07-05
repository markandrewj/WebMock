# Webmock

[![Build Status](https://img.shields.io/travis/wojteklu/WebMock/master.svg?style=flat-square)](https://travis-ci.org/wojteklu/WebMock) [![Platform support](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgrey.svg?style=flat-square)](https://github.com/wojteklu/WebMock/blob/master/LICENSE)  [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WebMock.svg?style=flat-square)](https://cocoapods.org/pods/WebMock)  [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)  [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/wojteklu/WebMock/blob/master/LICENSE)

HTTP/HTTPS requests stubbing for iOS and macOS. It works with NSURLSession, AFNetworking, Alamofire or any networking framework that use Cocoa's URL Loading System.

## Features
* Stub HTTP and HTTPS requests.
* Stub requests with errors.
* Define response with NSData, JSON object or file URL.
* Works with AFNetworking, Alamofire and more.
* Stub only requests you define.
* Tested.

## Usage

WebMock requires using session configuration's replacements instead of default ones.

```swift
let defaultConfiguration = NSURLSessionConfiguration.webmockDefaultSessionConfiguration()

let ephemeralConfiguration = NSURLSessionConfiguration.webmockEphemeralSessionConfiguration()
```

###Stub requests with NSData

```swift
let data = "test".dataUsingEncoding(NSUTF8StringEncoding)
let response = Response(data: data)

let URL = NSURL(string: "https://www.google.com")!
let stub = Stub(method: .GET, URL: URL, response: response)

WebMock.startWithStubs([stub])
```

###Stub requests with a JSON object

```swift
let json = ["testKey": "testValue"]
let response = Response(json: json)

let URL = NSURL(string: "https://www.google.com")!
let stub = Stub(method: .GET, URL: URL, response: response)

WebMock.startWithStubs([stub])
```

###Stub requests with a file

```swift
let fileURL = bundle.pathForResource("test", ofType: "json")!
let response = Response(fileURL: fileURL)

let URL = NSURL(string: "https://www.google.com")!
let stub = Stub(method: .GET, URL: URL, response: response)

WebMock.startWithStubs([stub])
```

###Stub requests with failure

```swift
let error = NSError(domain: NSInternalInconsistencyException,
                            code: 0,
                            userInfo: nil)        
let response = Response(error: error)

let URL = NSURL(string: "https://www.google.com")!
let stub = Stub(method: .GET, URL: URL, response: response)

WebMock.startWithStubs([stub])
```
You can additionaly define response's header fields and http method.

## Installation

### [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

Add the following to your Cartfile:

```
github "wojteklu/WebMock"
```
Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

### [CocoaPods]

[CocoaPods]: http://cocoapods.org

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```ruby
pod 'WebMock'
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install`.

### Manually

Manually add the file into your Xcode project. Slightly simpler, but updates are also manual.

## Author

Wojtek Lukaszuk [@wojteklu](http://twitter.com/wojteklu)

## License

WebMock is available under the MIT license. See the LICENSE file for more info.
