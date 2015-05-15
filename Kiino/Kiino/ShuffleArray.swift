//
//  ShuffleArray.swift
//  Kiino
//
//  Created by Carlos Guerrero on 5/15/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}