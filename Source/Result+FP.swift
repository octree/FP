//
//  Result.swift
//  RxDemo
//
//  Created by Octree on 2016/10/28.
//  Copyright © 2016年 Octree. All rights reserved.
//

import Foundation



public func <^> <T, U, E>(f: (T) -> U, v: Result<T, E>) -> Result<U, E> {

    return v.map(f)
}

public func <*> <T, U, E>(mf: Result<(T) -> U, E>, v: Result<T, E>) -> Result <U, E> {

    return mf.flatMap(v.map)
}

public func >>- <T, U, E>(v: Result<T, E>, f: (T) -> Result<U, E>) -> Result<U, E> {

    return v.flatMap(f)
}

public func -<< <T, U, E>(f: (T) -> Result<U, E>, v: Result<T, E>) -> Result<U, E> {

    return v.flatMap(f)
}

public func >-> <T, U, V, E>(f: @escaping (T) -> Result<U, E>, g: @escaping (U) -> Result<V, E> ) -> (T) -> Result<V, E> {

    return { x in f(x) >>- g }
}


public func <-< <T, U, V, E>(f: @escaping (U) -> Result<V, E>, g: @escaping (T) -> Result<U, E>) -> (T) -> Result<V, E> {

    return { x in g(x) >>- f }
}
