//
//  Result+Equatable.swift
//  ResultType
//
//  Created by Vijaya Prakash Kandel on 07.07.17.
//  Copyright © 2017 kandelvijaya.com. All rights reserved.
//

import Foundation

extension Result: Equatable {

    public static func ==(lhs: Result, rhs: Result) -> Bool {
        if case let .success(lv) = lhs, case let .success(rv) = rhs {
            return lv == rv
        }

        // If lhs and rhs are both .failure(Error), Error is not equatable
        // If lhs and rhs are different in context, then it is not a match
        return false
    }

}
