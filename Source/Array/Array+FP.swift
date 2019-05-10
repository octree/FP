//
//  Array+FP.swift
//  FP
//
//  Created by Octree on 2018/8/31.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

public extension Array {
    
    func apply<T>(_ mf: [(Element) -> T]) -> [T] {
        return mf.flatMap { self.map($0) }
    }
}

public func <^> <T, U>(f: (T) -> U, a: [T]) -> [U] {
    return a.map(f)
}

public func >>- <T, U>(a: [T], f: (T) -> [U]) -> [U] {
    return a.flatMap(f)
}

public func -<< <T, U>(f: (T) -> [U], a: [T]) -> [U] {
    return a.flatMap(f)
}


public func >-> <T, U, V>(f: @escaping (T) -> [U], g: @escaping (U) -> [V]) -> (T) -> [V] {
    return { x in f(x) >>- g }
}

public func <-< <T, U, V>(f: @escaping (U) -> [V], g: @escaping (T) -> [U]) -> (T) -> [V] {
    return { x in g(x) >>- f }
}

public func <*> <T, U>(fs: [(T) -> U], a: [T]) -> [U] {
    return a.apply(fs)
}

public func <* <T, U>(lhs: [T], rhs: [U]) -> [T] {
    return lhs.reduce([]) { accum, elem in
        accum + rhs.map { _ in elem }
    }
}

public func *> <T, U>(lhs: [T], rhs: [U]) -> [U] {
    return lhs.reduce([]) { accum, _ in
        accum + rhs
    }
}

public func <|> <T>(lhs: [T], rhs: @autoclosure () -> [T]) -> [T] {
    return lhs + rhs()
}
