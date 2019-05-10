//
//  State.swift
//  FP
//
//  Created by Octree on 2019/5/10.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

public struct State<S, A> {
    public let run: (S) -> (S, A)
}

public extension State {
    func fmap<B>(_ transform: @escaping (A) -> B) -> State<S, B> {
        return State<S, B>(run: { state in
            let result = self.run(state)
            return (result.0, transform(result.1))
        })
    }
    
    func then<B>(_ transform: @escaping (A) -> State<S, B>) -> State<S, B> {
        return State<S, B> { state in
            let result = self.run(state)
            return transform(result.1).run(result.0)
        }
    }
    
    func apply<B>(_ mf: State<S, (A) -> B>) -> State<S, B> {
        return mf.then(fmap)
    }
}


// operators

public func <^> <S, A, B>(f: @escaping (A) -> B, state: State<S, A>) -> State<S, B> {
    return state.fmap(f)
}

public func >>- <S, A, B>(state: State<S, A>, f: @escaping (A) -> State<S, B>) -> State<S, B> {
    return state.then(f)
}


public func -<< <S, A, B>(f: @escaping (A) -> State<S, B>, either: State<S, A>) -> State<S, B> {
    return either.then(f)
}

public func >-> <S, A, B, C>(f: @escaping (A) -> State<S, B>, g: @escaping (B) -> State<S, C>) -> (A) -> State<S, C> {
    return { x in f(x) >>- g }
}

public func <-< <S, A, B, C>(f: @escaping (B) -> State<S, C>, g: @escaping (A) -> State<S, B>) -> (A) -> State<S, C> {
    return { x in g(x) >>- f }
}

public func <*> <S, A, B>(mf: State<S, (A) -> B>, state: State<S, A>) -> State<S, B> {
    return state.apply(mf)
}

public func <* <S, A>(state1: State<S, A>, state2: State<S, A>) -> State<S, A> {
    return { x in { y in x }} <^> state1 <*> state2
}

public func *> <S, A>(state1: State<S, A>, state2: State<S, A>) -> State<S, A> {
    return { x in { y in y }} <^> state1 <*> state2
}
