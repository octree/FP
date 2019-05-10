//
//  Writer.swift
//  FP
//
//  Created by Octree on 2019/5/10.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation


public struct Writer<W: Monoid, A> {
    public let w: W
    public let a: A
    
    public func run() -> (A, W) {
        return (a, w)
    }
    
    public static func pure(_ a: A) -> Writer<W, A> {
        return Writer(w: W.mempty, a: a)
    }
    
    public static func tell(w: W) -> (A) -> Writer<W, A> {
        return {
            Writer(w: w, a: $0)
        }
    }
}

public extension Writer {
    
    func fmap<B>(_ transform: (A) -> B) -> Writer<W, B> {
        return Writer<W, B>(w: w, a: transform(a))
    }
    
    func then<B>(_ transform: (A) -> Writer<W, B>) -> Writer<W, B> {
        let result = transform(a)
        return Writer<W, B>(w: w <> result.w, a: result.a)
    }
    
    func apply<B>(_ mf: Writer<W, (A) -> B>) -> Writer<W, B> {
        return mf.then(fmap)
    }
}


public func <^> <W, A, B>(f: @escaping (A) -> B, writer: Writer<W, A>) -> Writer<W, B> {
    return writer.fmap(f)
}

public func >>- <W, A, B>(writer: Writer<W, A>, f: @escaping (A) -> Writer<W, B>) -> Writer<W, B> {
    return writer.then(f)
}

public func -<< <W, A, B>(f: @escaping (A) -> Writer<W, B>, writer: Writer<W, A>) -> Writer<W, B> {
    return writer.then(f)
}

public func >-> <W, A, B, C>(f: @escaping (A) -> Writer<W, B>, g: @escaping (B) -> Writer<W, C>) -> (A) -> Writer<W, C> {
    return { x in f(x) >>- g }
}

public func <-< <W, A, B, C>(f: @escaping (B) -> Writer<W, C>, g: @escaping (A) -> Writer<W, B>) -> (A) -> Writer<W, C> {
    return { x in g(x) >>- f }
}

public func <*> <W, A, B>(mf: Writer<W, (A) -> B>, writer: Writer<W, A>) -> Writer<W, B> {
    return writer.apply(mf)
}

public func <* <W, A>(writer1: Writer<W, A>, writer2: Writer<W, A>) -> Writer<W, A> {
    return { x in { y in x }} <^> writer1 <*> writer2
}

public func *> <W, A>(writer1: Writer<W, A>, writer2: Writer<W, A>) -> Writer<W, A> {
    return { x in { y in y }} <^> writer1 <*> writer2
}
