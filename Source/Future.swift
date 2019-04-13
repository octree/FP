//
//  Future.swift
//
//
//  Created by Octree on 2016/10/28.
//  Copyright © 2016年 Octree. All rights reserved.
//

import Foundation

public struct Future<T, E: Error> {
    
    let trunck: (@escaping (Result<T, E>) -> Void) -> Void
    
    public init(f: @escaping (@escaping (Result<T, E>) -> Void) -> Void) {
        
        trunck = f
    }
}


public extension Future {
    
    // execute
    
    func execute(callback: @escaping (Result<T, E>) -> Void) {
        
        trunck(callback)
    }

    // pure
    
    static func unit<T, E: Error>(_ v: T) -> Future<T, E> {
    
        return Future<T, E> { f in f(.success(v)) }
    }
    
    static func fail<T, E: Error>(_ error: E) -> Future<T, E> {
        
        return Future<T, E> { f in f(.failure(error)) }
    }
    
    // Functor
    
    func fmap<U>(f: @escaping (T) -> U) -> Future<U, E> {
        
        return then { Future.unit(f($0)) }
    }
    
    // Applicative
    
    // Monad
    
    func then<U>(f: @escaping (T) -> Future<U, E>) -> Future<U, E> {
        
        return Future<U, E> {
            cont in
            self.execute {
            
                switch $0.map(f) {
                    
                    case .success(let Future):
                        Future.execute(callback: cont)
                    case .failure(let e):
                        cont(.failure(e))
                }
            }
        }
    }
    
}


//  Operator

public func <^> <T, U, E: Error>(f: @escaping (T) -> U, v: Future<T, E>) -> Future<U, E> {

    return v.fmap(f: f)
}

public func >>- <T, U, E: Error>(v: Future<T, E>, f: @escaping (T) -> Future<U, E>) -> Future<U, E> {

    return v.then(f: f)
}

public func -<< <T, U, E: Error>(f: @escaping (T) -> Future<U, E>, v: Future<T, E>) -> Future<U, E> {
    
    return v.then(f: f)
}

public func >-> <T, U, V, E: Error>(f: @escaping (T) -> Future<U, E>, g: @escaping (U) -> Future<V, E>) -> (T) -> Future<V, E> {

    return { x in f(x) >>- g }
}

public func <-< <T, U, V, E: Error>(f: @escaping (U) -> Future<V, E>, g: @escaping (T) -> Future<U, E>) -> (T) -> Future<V, E> {

    return { x in g(x) >>- f }
}
