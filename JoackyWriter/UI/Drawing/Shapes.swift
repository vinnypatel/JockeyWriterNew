//
//  Shapes.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 02/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class Shape {
    
    let parts: [Part]
    
    init(_ letter: Character) {
        switch letter {
        case "A": parts = UppercaseLetters.A
        case "B": parts = UppercaseLetters.B
        case "C": parts = UppercaseLetters.C
        case "D": parts = UppercaseLetters.D
        case "E": parts = UppercaseLetters.E
        case "F": parts = UppercaseLetters.F
        case "G": parts = UppercaseLetters.G
        case "H": parts = UppercaseLetters.H
        case "I": parts = UppercaseLetters.I
        case "J": parts = UppercaseLetters.J
        case "K": parts = UppercaseLetters.K
        case "L": parts = UppercaseLetters.L
        case "M": parts = UppercaseLetters.M
        case "N": parts = UppercaseLetters.N
        case "O": parts = UppercaseLetters.O
        case "P": parts = UppercaseLetters.P
        case "Q": parts = UppercaseLetters.Q
        case "R": parts = UppercaseLetters.R
        case "S": parts = UppercaseLetters.S
        case "T": parts = UppercaseLetters.T
        case "U": parts = UppercaseLetters.U
        case "V": parts = UppercaseLetters.V
        case "W": parts = UppercaseLetters.W
        case "X": parts = UppercaseLetters.X
        case "Y": parts = UppercaseLetters.Y
        case "Z": parts = UppercaseLetters.Z
            
        case "a": parts = LowercaseLetters.a
        case "b": parts = LowercaseLetters.b
        case "c": parts = LowercaseLetters.c
        case "d": parts = LowercaseLetters.d
        case "e": parts = LowercaseLetters.e
        case "f": parts = LowercaseLetters.f
        case "g": parts = LowercaseLetters.g
        case "h": parts = LowercaseLetters.h
        case "i": parts = LowercaseLetters.i
        case "j": parts = LowercaseLetters.j
        case "k": parts = LowercaseLetters.k
        case "l": parts = LowercaseLetters.l
        case "m": parts = LowercaseLetters.m
        case "n": parts = LowercaseLetters.n
        case "o": parts = LowercaseLetters.o
        case "p": parts = LowercaseLetters.p
        case "q": parts = LowercaseLetters.q
        case "r": parts = LowercaseLetters.r
        case "s": parts = LowercaseLetters.s
        case "t": parts = LowercaseLetters.t
        case "u": parts = LowercaseLetters.u
        case "v": parts = LowercaseLetters.v
        case "w": parts = LowercaseLetters.w
        case "x": parts = LowercaseLetters.x
        case "y": parts = LowercaseLetters.y
        case "z": parts = LowercaseLetters.z
            
        case "0": parts = Numbers.null
        case "1": parts = Numbers.one
        case "2": parts = Numbers.two
        case "3": parts = Numbers.three
        case "4": parts = Numbers.four
        case "5": parts = Numbers.five
        case "6": parts = Numbers.six
        case "7": parts = Numbers.seven
        case "8": parts = Numbers.eight
        case "9": parts = Numbers.nine
    
        default: parts = UppercaseLetters.A
        }
    }
    
}

class Part {
    
    var trace = [CGPoint]()
    
    init(trace: [CGPoint]) {
        self.trace = trace
    }
}
