//
//  Async.swift
//
//
//  Created by Octree on 2016/10/28.
//  Copyright © 2016年 Octree. All rights reserved.
//

import Foundation

public struct Async<T, E: Error> {
    
    public let run: (@escaping (Result<T, E>) -> Void) -> Void
    
    public init(f: @escaping (@escaping (Result<T, E>) -> Void) -> Void) {
        
        run = f
    }
}


public extension Async {
    
    // execute
    func execute(callback: @escaping (Result<T, E>) -> Void) {
        
        run(callback)
    }

    // pure
    static func unit<T, E: Error>(_ v: T) -> Async<T, E> {
    
        return Async<T, E> { f in f(.success(v)) }
    }
    
    static func fail<T, E: Error>(_ error: E) -> Async<T, E> {
        
        return Async<T, E> { f in f(.failure(error)) }
    }
    
    // Functor
    func fmap<U>(_ transform: @escaping (T) -> U) -> Async<U, E> {
        
        return then { Async.unit(transform($0)) }
    }
    
    // Monad
    func then<U>(_ transform: @escaping (T) -> Async<U, E>) -> Async<U, E> {
        return Async<U, E> {
            cont in
            self.execute {
                switch $0.map(transform) {
                    
                    case .success(let Async):
                        Async.execute(callback: cont)
                    case .failure(let e):
                        cont(.failure(e))
                }
            }
        }
    }
    
    // Applicative
    func apply<U>(_ mf: Async<(T) -> U, E>) -> Async<U, E> {
        return mf.then(fmap)
    }
    
}

//  Operator

public func <^> <T, U, E: Error>(f: @escaping (T) -> U, v: Async<T, E>) -> Async<U, E> {
    return v.fmap(f)
}

public func >>- <T, U, E: Error>(v: Async<T, E>, f: @escaping (T) -> Async<U, E>) -> Async<U, E> {
    return v.then(f)
}

public func -<< <T, U, E: Error>(f: @escaping (T) -> Async<U, E>, v: Async<T, E>) -> Async<U, E> {
    return v.then(f)
}

public func >-> <T, U, V, E: Error>(f: @escaping (T) -> Async<U, E>, g: @escaping (U) -> Async<V, E>) -> (T) -> Async<V, E> {
    return { x in f(x) >>- g }
}

public func <-< <T, U, V, E: Error>(f: @escaping (U) -> Async<V, E>, g: @escaping (T) -> Async<U, E>) -> (T) -> Async<V, E> {
    return { x in g(x) >>- f }
}

public func <|> <V, E>(async1: Async<V, E>, async2: Async<V, E>) -> Async<V, E> {
    return Async<V, E> { cont in
        async1.run { result in
            switch result {
            case .success(_):
                cont(result)
            case .failure(_):
                async2.run(cont)
            }
        }
    }
}

public func <*> <V, W, E>(mf: Async<(V) -> W, E>, async: Async<V, E>) -> Async<W, E> {
    return async.apply(mf)
}

public func <* <V, E>(async1: Async<V, E>, async2: Async<V, E>) -> Async<V, E> {
    return { x in { y in x }} <^> async1 <*> async2
}

public func *> <V, E>(async1: Async<V, E>, async2: Async<V, E>) -> Async<V, E> {
    return { x in { y in y }} <^> async1 <*> async2
}
