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
