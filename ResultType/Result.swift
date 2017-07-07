//
//  Result.swift
//  ResultType
//
//  Created by Vijaya Prakash Kandel on 07.07.17.
//  Copyright © 2017 kandelvijaya.com. All rights reserved.
//

import Foundation

public enum Result<Value: Equatable> {

    case success(value: Value)
    case failure(Error)

}


//MARK:- Functor
public extension Result {

    /**
     Result (as Functor) provides mapping ability to the internal elements.
     - parameter transform: Transformation (mapping) that will be applied to internal item if it is `.success`
     - returns: Mapped value is wrapped in Result. If the internal item representes `failure` case then that same `failure` is returned without any transformation.
     */
    public func fmap<T>(_ transform: (Value) -> T) -> Result<T> {
        switch self {
        case let .success(v):
            let transformed = transform(v)
            return Result<T>.success(value: transformed)
        case let .failure(e):
            return .failure(e)
        }
    }

}




//MARK:- Monad
public extension Result {

    /**
     Result (as Monad) provides composing ability to Result types without the need to
     peek into the internal of Result.

     - parameter toTransform: a function that will take the internal value of the current Result type and compute.
     - returns: new Result type
     */
    public func bind<T>(_ toTransform: (Value) -> Result<T>) -> Result<T> {
        let mapped = self.fmap(toTransform)
        return Result.flatten(mapped)
    }

}




extension Result {

    /**
     Lifting vlaue (in Haskell its called `pure` or `return`) to a contextual (Monad) type.
     - parameter input: Any Value of `T`
     - returns: Result<T> where the input is wrapped into `.success`

     This is useful for chaining a normal value to a transfrom with `bind`.
     For example:

         func divRandom(_ numerator: Int) -> Result<Int> {
             let randomDenominator = arc4random() % 100
             if randomDenominator == 0 {
                 return Result<Int>.failure(CannotDivideByZero)
             } else {
                 return Result<Int>.success(numerator / denominator)
             }
         }

         let a = 12
         let liftedA = Result.lift(12)
         let computed = liftedA.bind(divRandom)

     The above example is trivial but is useful construct to have. Lifting allows one to think of only Type rather than each element of that Type.
     */
    static func lift<T>(_ input: T) -> Result<T> {
        return Result<T>.success(value: input)
    }




    /**
     Flatten (also known as `join` or `concat`), unwraps 1 level of Monad, if multilevel exists.
     - note: this is a static function not by choice but by language limitation that wont allow one to express extension like such

         extension Result where Value == Result {

     - parameter input: Result Monad wrapped in Result type. This can be 2 or more levels wrapping.
     - returns: 1 level unwrapped Result type. `Result<Result<Int>> -> Result<Int>`. During the unwrapping, both the deepest `success` and `failure` are preserved.
     */
    static func flatten<T>(_ input: Result<Result<T>>) -> Result<T> {
        switch input {
        case let .success(.success(v)):
            return .success(value: v)
        case let .success(.failure(e)):
            return .failure(e)
        case let .failure(e):
            return .failure(e)
        }
    }

}
