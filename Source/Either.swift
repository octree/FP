//
//  Either.swift
//  FP
//
//  Created by Octree on 2019/3/7.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation


/// The Either type represents values with two possibilities:
/// A value of type Either<A, B> is either .left(a) or .right(b) .
public enum Either<A, B> {
    case left(A)
    case right(B)
}


// MARK: - Functor Monad & Applicative
public extension Either {
    
    /// functor
    public func map<B1>(f: (B) -> B1) -> Either<A, B1> {
        
        switch self {
        case .left(let val):
            return .left(val)
        case .right(let val):
            return .right(f(val))
        }
    }
    
    /// monad
    public func then<B1>(f: (B) -> Either<A, B1>) -> Either<A, B1> {
        switch self {
        case .left(let val):
            return .left(val)
        case .right(let val):
            return f(val)
        }
    }
    
    
    /// applicative
    public func apply<B1>(mf: Either<A, (B) -> B1>) -> Either<A, B1> {
        
        return mf.then(f: map)
    }
}


/// functor operator
public func <^> <A, B, B1>(f: (B) -> B1, either: Either<A, B>) -> Either<A, B1> {
    
    return either.map(f: f)
}

public func >>- <A, B, B1>(either: Either<A, B>, f: (B) -> Either<A, B1>) -> Either<A, B1> {
    
    return either.then(f: f)
}


public func -<< <A, B, B1>(f: (B) -> Either<A, B1>, either: Either<A, B>) -> Either<A, B1> {
    
    return either.then(f: f)
}

public func >-> <A, B, B1, B2>(f: @escaping (B) -> Either<A, B1>, g: @escaping (B1) -> Either<A, B2>) -> (B) -> Either<A, B2> {
    
    return { x in f(x) >>- g }
}

public func <-< <A, B, B1, B2>(f: @escaping (B1) -> Either<A, B2>, g: @escaping (B) -> Either<A, B1>) -> (B) -> Either<A, B2> {
    
    return { x in g(x) >>- f }
}

public func <|> <A, B>(either1: Either<A, B>, either2: Either<A, B>) -> Either<A, B> {
    
    switch either1 {
    case .left(_):
        return either2
    default:
        return either1
    }
}

public func <*> <A, B, B1>(mf: Either<A, (B) -> B1>, either: Either<A, B>) -> Either<A, B1> {
    
    return either.apply(mf: mf)
}

public func <* <A, B>(either1: Either<A, B>, either2: Either<A, B>) -> Either<A, B> {
    
    return { x in { y in x }} <^> either1 <*> either2
}

public func *> <A, B>(either1: Either<A, B>, either2: Either<A, B>) -> Either<A, B> {
    
    return { x in { y in y }} <^> either1 <*> either2
}
