//
//  Monoid.swift
//  FP
//
//  Created by Octree on 2019/5/10.
//  Copyright © 2019 Octree. All rights reserved.
//

import Foundation

/// haskell Monoid mappend operator
/// infixr 6 <>
/// associativity is different to haskell
infix operator <> : AdditionPrecedence

public protocol Monoid {
    static var mempty: Self { get }
    func mappend(m: Self) -> Self
}

extension String: Monoid {
    public static var mempty: String {
        return ""
    }
    
    public func mappend(m: String) -> String {
        return self + m
    }
}


extension Double: Monoid {
    public static var mempty: Double {
        return 0
    }
    
    public func mappend(m: Double) -> Double {
        return self + m
    }
}

extension Float: Monoid {
    public static var mempty: Float {
        return 0
    }
    
    public func mappend(m: Float) -> Float {
        return self + m
    }
}

extension Int: Monoid {
    public static var mempty: Int {
        return 0
    }
    
    public func mappend(m: Int) -> Int {
        return self + m
    }
}

extension Int8: Monoid {
    public static var mempty: Int8 {
        return 0
    }
    
    public func mappend(m: Int8) -> Int8 {
        return self + m
    }
}

extension Int16: Monoid {
    public static var mempty: Int16 {
        return 0
    }
    
    public func mappend(m: Int16) -> Int16 {
        return self + m
    }
}


extension Int32: Monoid {
    public static var mempty: Int32 {
        return 0
    }
    
    public func mappend(m: Int32) -> Int32 {
        return self + m
    }
}

extension Int64: Monoid {
    public static var mempty: Int64 {
        return 0
    }
    
    public func mappend(m: Int64) -> Int64 {
        return self + m
    }
}


extension UInt: Monoid {
    public static var mempty: UInt {
        return 0
    }
    
    public func mappend(m: UInt) -> UInt {
        return self + m
    }
}

extension UInt8: Monoid {
    public static var mempty: UInt8 {
        return 0
    }
    
    public func mappend(m: UInt8) -> UInt8 {
        return self + m
    }
}


extension UInt16: Monoid {
    public static var mempty: UInt16 {
        return 0
    }
    
    public func mappend(m: UInt16) -> UInt16 {
        return self + m
    }
}

extension UInt32: Monoid {
    public static var mempty: UInt32 {
        return 0
    }
    
    public func mappend(m: UInt32) -> UInt32 {
        return self + m
    }
}

extension UInt64: Monoid {
    public static var mempty: UInt64 {
        return 0
    }
    
    public func mappend(m: UInt64) -> UInt64 {
        return self + m
    }
}

extension Array: Monoid {
    public static var mempty: Array<Element> {
        return []
    }
    
    public func mappend(m: Array<Element>) -> Array<Element> {
        return self + m
    }
}

public func <> <T: Monoid>(lhs: T, rhs: T) -> T {
    return lhs.mappend(m: rhs)
}
