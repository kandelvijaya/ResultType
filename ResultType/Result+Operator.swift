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

/**
 `bind` can be convienienty accessed by substituting `>>=`
 This operator gives elagance to the code both in terms of
 readability to the reader and notion of chaining to the author.
 */
infix operator >>=: BindFunctionCompositionPrecedence


/**
 `>>=` is defined in terms of `bind`. It provides a concise and readable
 syntax/operator for composing functions.
 */
func >>= <T,U>(_ lhs: Result<T>, _ rhsFunction: ((T) -> Result<U>)) -> Result<U> {
    return lhs.bind(rhsFunction)
}

