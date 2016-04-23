//
//  Matcher.swift
//  WebMock
//
//  Created by Wojtek on 19/04/2016.
//  Copyright © 2016 wojteklu. All rights reserved.
//

extension SequenceType {
    
    func find(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Self.Generator.Element? {
        for element in self {
            if try predicate(element) {
                return element
            }
        }
        return nil
    }
}
