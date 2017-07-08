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

    //MARK:- Functor tests

    func testWhenFmapIsAppliedOnResultWithSuccessCase_thenSuccessValueIsMapped() {
        let givenResult = Result<Int>.lift(12)
        let output = givenResult.fmap { $0 * 2 }

        guard case let .success(v) = output, v == 24 else {
            XCTFail()
            return
        }
    }

    func testWhenFmapIsAppliedOnResultWithFailureCase_thenOriginalResultIsUnchanged() {
        let givenResult = Result<String>.failure(MockError(kind: .badCharacter))
        let output = givenResult.fmap { $0.uppercased() }

        guard case let .failure(iE) = givenResult, case let .failure(oE) = output,
            let originalError = iE as? MockError, let obtainedError = oE as? MockError,
            originalError.kind == obtainedError.kind else {
                XCTFail()
                return
        }

    }


    // MARK:- Monad tests
    // IMPORTANT: Cannot test `>>=` becuase this operator is defined in the standard library
    // similar to `+=`, `*=`.

    func testWhenBindIsAppliedOnResultWithSuccessCase_thenSuccessValueIsBinded() {
        let givenResult = Result<Int>.lift(200)
        let bindOutput = givenResult.bind(TestHelper.divideBy100)
        guard case let .success(v) = bindOutput, v == 2 else {
            XCTFail()
            return
        }
    }

    func testWhenBindIsAppliedOnResultWithSuccessCase_thenSuccessValueIsBindedAndReturnsTheOutputOfSecondFunction() {
        let givenResult = Result<Int>.lift(200)
        let bindOutput = givenResult.bind(TestHelper.divideBy0)

        guard case let .failure(e) = bindOutput, let error = e as? MockError, error.kind == .cannotDivideByZero else {
            XCTFail()
            return
        }
    }

    func testWhenBindIsAppliedOnResultWithFailureCase_thenOriginalFailureIsReturnedAsIs() {
        let givenResult = Result<String>.failure(MockError(kind: .badCharacter))
        let bindOutput = givenResult.bind(TestHelper.stringToInt).bind(TestHelper.divideBy100)

        guard case let .failure(e) = bindOutput, let error = e as? MockError, error.kind == .badCharacter else {
            XCTFail()
            return
        }
    }

    func testWhenBindIsAppliedOnResultWithFailureCase_thenLaterFunctionsAreNotExecutedAtAll() {
        let givenResult = Result<String>.failure(MockError(kind: .badCharacter))

        //TODO: use state monad to get rid of this side effect state testing
        TestHelper.stackTrace.removeAll()
        let bindOutput = givenResult.bind(TestHelper.stringToInt).bind(TestHelper.divideBy100)

        guard case let .failure(e) = bindOutput, let error = e as? MockError, error.kind == .badCharacter else {
            XCTFail()
            return
        }

        if TestHelper.stackTrace.contains(.stringToInt) || TestHelper.stackTrace.contains(.divideBy100) {
            XCTFail()
        }

    }
    
}



struct MockError: Error {

    enum ErrorKind: String {
        case cannotDivideByZero
        case badCharacter
        case stringToIntConversionFailure
    }
    var kind: ErrorKind

}


final class TestHelper {

    enum Functions {
        case divideBy100
        case divideBy0
        case stringToInt
    }

    static var stackTrace = [Functions]()

    static func divideBy100(_ input: Int) -> Result<Int> {
        stackTrace.append(.divideBy100)
        return Result<Int>.success(value: input / 100)
    }

    static func divideBy0(_ input: Int) -> Result<Int> {
        stackTrace.append(.divideBy0)
        return Result<Int>.failure(MockError(kind: .cannotDivideByZero))
    }

    static func stringToInt(_ input: String) -> Result<Int> {
        stackTrace.append(.stringToInt)
        let int = Int(input)
        switch int {
        case let .some(v):
            return Result<Int>.success(value: v)
        default:
            return Result<Int>.failure(MockError(kind: .stringToIntConversionFailure))
        }
    }

}


