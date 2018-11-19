//
//  Optional+FP.swift
//  FP
//
//  Created by Octree on 2018/9/1.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

public func <^> <T, U>(f: (T) -> U, a: T?) -> U? {
    return a.map(f)
}


public func >>- <T, U>(a: T?, f: (T) -> U?) -> U? {
    return a.flatMap(f)
}

public func -<< <T, U>(f: (T) -> U?, a: T?) -> U? {
    return a.flatMap(f)
}

public func >-> <T, U, V>(f: @escaping (T) -> U?, g: @escaping (U) -> V?) -> (T) -> V? {
    return { x in f(x) >>- g }
}

public func <-< <T, U, V>(f: @escaping (U) -> V?, g: @escaping (T) -> U?) -> (T) -> V? {
    return { x in g(x) >>- f }
}

public func <*> <T, U>(f: ((T) -> U)?, a: T?) -> U? {
    return a.apply(f)
}

public func <* <T, U>(lhs: T?, rhs: U?) -> T? {
    switch rhs {
    case .none: return .none
    case .some: return lhs
    }
}

public func *> <T, U>(lhs: T?, rhs: U?) -> U? {
    switch lhs {
    case .none: return .none
    case .some: return rhs
    }
}


public extension Optional {

    func apply<T>(_ f: ((Wrapped) -> T)?) -> T? {
        return f.flatMap { self.map($0) }
    }
}

public func <|> <T>(lhs: T?, rhs: @autoclosure () -> T?) -> T? {
    return lhs.or(rhs)
}

public extension Optional {
    func or(_ other: @autoclosure () -> Wrapped?) -> Wrapped? {
        switch self {
        case .some: return self
        case .none: return other()
        }
    }
}
