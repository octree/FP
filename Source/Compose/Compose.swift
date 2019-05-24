//
//  Compose.swift
//  FP
//
//  Created by Octree on 2019/5/13.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

precedencegroup ComposePrecedence {
    associativity: left
    higherThan: BitwiseShiftPrecedence
}

infix operator |> : ComposePrecedence

public func |> <T, U, V>(lhs: @escaping (T) -> U, rhs: @escaping (U) -> V) -> (T) -> V {
    return { rhs(lhs($0)) }
}
