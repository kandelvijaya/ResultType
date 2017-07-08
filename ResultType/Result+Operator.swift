//
//  Result+Operator.swift
//  ResultType
//
//  Created by Vijaya Prakash Kandel on 08.07.17.
//  Copyright © 2017 kandelvijaya.com. All rights reserved.
//

import Foundation


precedencegroup BindFunctionCompositionPrecedence {

    // BitwiseShiftPrecedence is higher than Multiplicative ones ( * ,  /)
    higherThan: BitwiseShiftPrecedence

    // x >>= y >>= z
    // is the same as (x >>= y) >>= z
    associativity: left

}

infix operator >>=: BindFunctionCompositionPrecedence


/**
 `>>>` is defined in terms of `bind`. It provides a concise and readable
 syntax/operator for composing functions.

 - important: This operator is defined in swift-core as `>>=` similar to `*=` or `+=`
 This might not work well with the tests.
 */
func >>= <T,U>(_ lhs: Result<T>, _ rhsFunction: (T) -> Result<U>) -> Result<U> {
    return lhs.bind(rhsFunction)
}

