//
//  Reader.swift
//  FP
//
//  Created by Octree on 2019/5/10.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

public struct Reader<Environment, A> {
    
    public let run: (Environment) -> A
}

public extension Reader {
    
    func fmap<B>(_ transform: @escaping (A) -> B) -> Reader<Environment, B> {
        return Reader<Environment, B>(run: { env in
            return transform(self.run(env))
        })
    }
    
    func then<B>(_ transform: @escaping (A) -> Reader<Environment, B>) -> Reader<Environment, B> {
        return Reader<Environment, B>(run: { env in
            return transform(self.run(env)).run(env)
        })
    }
    
    func apply<B>(_ mf: Reader<Environment, (A) -> B>) -> Reader<Environment, B> {
        return mf.then(fmap)
    }
}


public func <^> <E, A, B>(f: @escaping (A) -> B, reader: Reader<E, A>) -> Reader<E, B> {
    return reader.fmap(f)
}

public func >>- <E, A, B>(reader: Reader<E, A>, f: @escaping (A) -> Reader<E, B>) -> Reader<E, B> {
    return reader.then(f)
}

public func -<< <E, A, B>(f: @escaping (A) -> Reader<E, B>, reader: Reader<E, A>) -> Reader<E, B> {
    return reader.then(f)
}

public func >-> <E, A, B, C>(f: @escaping (A) -> Reader<E, B>, g: @escaping (B) -> Reader<E, C>) -> (A) -> Reader<E, C> {
    return { x in f(x) >>- g }
}

public func <-< <E, A, B, C>(f: @escaping (B) -> Reader<E, C>, g: @escaping (A) -> Reader<E, B>) -> (A) -> Reader<E, C> {
    return { x in g(x) >>- f }
}

public func <*> <E, A, B>(mf: Reader<E, (A) -> B>, reader: Reader<E, A>) -> Reader<E, B> {
    return reader.apply(mf)
}

public func <* <E, A>(reader1: Reader<E, A>, reader2: Reader<E, A>) -> Reader<E, A> {
    return { x in { y in x }} <^> reader1 <*> reader2
}

public func *> <E, A>(reader1: Reader<E, A>, reader2: Reader<E, A>) -> Reader<E, A> {
    return { x in { y in y }} <^> reader1 <*> reader2
}
