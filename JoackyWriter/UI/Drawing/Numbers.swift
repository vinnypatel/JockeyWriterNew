//
//  Numbers.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 18/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class Numbers {
    
    static var null: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(112, 54), (52, 91), (41, 155), (52, 220), (112, 256), (171, 220), (182, 155), (171, 91), (112, 54)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var one: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(41, 95), (80, 60), (80, 123), (80, 186), (80, 249)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var two: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(45, 110), (93, 57), (162, 84), (147, 152), (89, 189), (43, 249)],
                [(43, 252), (104, 252), (165, 252)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var three: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(44, 92), (106, 48), (165, 92), (106, 140)],
                 [(106, 140), (166, 170), (162, 230), (98, 250), (40, 202)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var four: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(137, 58), (98, 103), (64, 148), (35, 196), (80, 196), (125, 196), (170, 196)],
                 [(137, 58), (137, 121), (137, 184), (137, 248)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var five: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(149, 56), (68, 56)],
                 [(68, 56), (51, 145)],
                 [(51, 145), (121, 127), (171, 175), (159, 233), (98, 252), (40, 207)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var six: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(169, 78), (102, 49), (47, 100), (43, 165), (64, 230), (132, 248), (176, 200), (156, 141), (99, 129), (43, 165)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var seven: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(37, 51), (97, 51), (157, 51)],
                 [(157, 51), (115, 110), (80, 177), (65, 248)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var eight: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(111, 48), (54, 80), (83, 134), (144, 144), (183, 185), (168, 235), (111, 252)],
                 [(111, 252), (59, 232), (41, 183), (83, 144), (144, 134), (170, 80), (111, 48)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var nine: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(106, 48), (46, 77), (49, 143), (106, 171), (161, 143), (161, 77), (106, 48)],
                 [(106, 48), (163, 82), (174, 150), (159, 219), (106, 250), (44, 210)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
}
