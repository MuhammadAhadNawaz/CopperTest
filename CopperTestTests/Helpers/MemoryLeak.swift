//
//  MemoryLeak.swift
//  CopperTestTests
//
//  Created by Muhammad Ahad on 01/08/2021.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [ weak instance ] in
            XCTAssertNil(instance, "make sure the instance is deallocated", file: file, line: line)
        }
    }
}

