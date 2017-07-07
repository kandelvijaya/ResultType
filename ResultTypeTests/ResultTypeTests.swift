//
//  ResultTypeTests.swift
//  ResultTypeTests
//
//  Created by Vijaya Prakash Kandel on 07.07.17.
//  Copyright © 2017 kandelvijaya.com. All rights reserved.
//

import XCTest
@testable import ResultType

final class ResultTypeTests: XCTestCase {
    
    func testWhenFmapIsAppliedOnResultWithSuccessCase_thenSuccessValueIsMapped() {
        let givenResult = Result<Int>.lift(12)
        let expected = Result<Int>.success(value: 24)

        let output = givenResult.fmap { $0 * 2}
        let isEqual = expected == output
        XCTAssertTrue(isEqual)
    }

    func testWhenFmapIsAppliedOnResultWithFailureCase_thenOriginalResultIsUnchanged() {
        enum StringError: Error {
            case BadCahracter
        }

        let givenResult = Result<String>.failure(StringError.BadCahracter)
        let output = givenResult.fmap { $0.uppercased() }

        if case let .failure(originalError) = givenResult, case let .failure(obtainedError) = output {
            XCTAssertEqual(obtainedError.localizedDescription, StringError.BadCahracter.localizedDescription)
            XCTAssertEqual(originalError.localizedDescription, obtainedError.localizedDescription)
        } else {
            XCTFail()
        }
    }
    
}
