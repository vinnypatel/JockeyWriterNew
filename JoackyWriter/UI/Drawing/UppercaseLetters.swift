//
//  UppercaseLetters.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 16/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class UppercaseLetters {
    
    static var A: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(108, 45), (89, 96), (71, 148), (54, 199), (38, 250)],
                 [(126, 45), (146, 96), (165, 148), (184, 199), (203, 250)],
                 [(62, 178), (114, 178), (175, 178)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var B: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(55, 40), (55, 92), (55, 145), (55, 198), (55, 250)],
                 [(55, 43), (110, 43), (165, 45), (196, 85), (165, 132), (110, 137), (55, 137)],
                 [(55, 145), (110, 145), (165, 147), (200, 173), (200, 219), (165, 245), (110, 248), (55, 248)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var C: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(212, 97), (176, 52), (116, 42), (64, 75), (44, 137), (54, 199), (96, 244), (164, 247), (211, 195)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var D: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(54, 40), (54, 92), (54, 145), (54, 198), (54, 250)],
                 [(54, 43), (107, 43), (160, 49), (198, 82), (211, 145), (198, 208), (160, 241), (107, 247), (54, 247)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var E: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(54, 40), (54, 92), (54, 145), (54, 198), (54, 250)],
                 [(58, 43), (125, 43), (193, 43)],
                 [(58, 139), (123, 139), (189, 139)],
                 [(58, 247), (125, 247), (193, 247)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var F: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(54, 40), (54, 92), (54, 145), (54, 198), (54, 250)],
                 [(56, 43), (116, 43), (175, 43)],
                 [(56, 139), (112, 139), (168, 139)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var G: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(209, 85), (156, 43), (86, 52), (47, 110), (47, 182), (88, 239), (161, 247), (210, 197), (216, 150), (156, 149)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var H: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(58, 40), (58, 92), (58, 145), (58, 198), (58, 250)],
                 [(212, 40), (212, 92), (212, 145), (212, 198), (212, 250)],
                 [(58, 140), (133, 140), (212, 140)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var I: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(63, 40), (63, 92), (63, 145), (63, 198), (63, 250)],
                 [(43, 43), (83, 43)],
                 [(43, 247), (83, 247)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var J: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(149, 40), (149, 100), (149, 160), (144, 220), (86, 248), (42, 194)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var K: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(53, 40), (53, 92), (53, 145), (53, 198), (53, 250)],
                 [(193, 42), (149, 83), (107, 127), (60, 166)],
                 [(115, 128), (143, 168), (175, 208), (205, 248)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var L: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(53, 40), (53, 92), (53, 145), (53, 198), (53, 250)],
                 [(59, 247), (122, 247), (185, 247)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var M: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(56, 40), (56, 92), (56, 145), (56, 198), (56, 250)],
                 [(65, 42), (89, 90), (108, 143), (128, 196), (149, 250)],
                 [(157, 250), (178, 196), (198, 143), (217, 90), (241, 43)],
                 [(250, 40), (250, 92), (250, 145), (250, 198), (250, 250)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var N: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(58, 40), (58, 92), (58, 145), (58, 198), (58, 250)],
                 [(63, 45), (98, 95), (132, 144), (165, 194), (203, 244)],
                 [(208, 250), (208, 198), (208, 145), (208, 92), (208, 40)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var O: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(141, 41), (79, 63), (46, 115), (46, 181), (79, 233), (141, 255), (203, 233), (236, 181), (236, 115), (203, 63), (141, 41)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var P: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(54, 40), (54, 92), (54, 145), (54, 198), (54, 250)],
                 [(58, 43), (123, 43), (186, 64), (186, 125), (123, 145), (58, 145)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var Q: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(141, 41), (79, 63), (46, 115), (46, 181), (79, 233), (141, 255), (203, 233), (236, 181), (236, 115), (203, 63), (141, 41)],
                 [(174, 215), (217, 277)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var R: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(55, 40), (55, 92), (55, 145), (55, 198), (55, 250)],
                 [(60, 43), (121, 43), (182, 48), (211, 90), (182, 133), (121, 140), (60, 140)],
                 [(60, 144), (132, 144), (192, 170), (204, 250)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var S: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(190, 77), (128, 39), (60, 77), (88, 127), (158, 149), (198, 197), (158, 247), (88, 245), (45, 194)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var T: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(110, 40), (110, 92), (110, 145), (110, 198), (110, 250)],
                 [(35, 43), (110, 43), (185, 43)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var U: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(57, 39), (57, 104), (57, 171), (73, 227), (135, 250), (196, 227), (212, 169), (212, 104), (212, 39)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var V: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(37, 39), (54, 89), (72, 139), (89, 189), (108, 239)],
                 [(120, 239), (139, 189), (156, 139), (174, 89), (191, 39)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var W: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(38, 42), (51, 93), (64, 143), (79, 193), (95, 243)],
                 [(101, 243), (116, 193), (129, 144), (141, 95), (157, 45)],
                 [(173, 45), (187, 95), (200, 144), (212, 193), (229, 243)],
                 [(235, 243), (251, 193), (265, 143), (278, 93), (291, 42)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var X: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(44, 42), (80, 93), (114, 144), (150, 195), (186, 246)],
                 [(183, 42), (147, 93), (114, 144), (78, 195), (41, 246)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var Y: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(35, 40), (75, 97), (119, 160)],
                 [(203, 40), (163, 97), (119, 160), (119, 246)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
    
    static var Z: [Part] {
        get {
            let coordinates: [[(CGFloat, CGFloat)]] =
                [[(58, 43), (130, 43), (201, 43)],
                 [(201, 47), (166, 95), (129, 143), (92, 191), (59, 240)],
                 [(58, 247), (110, 247), (163, 247), (216, 247)]]
            return Utils.parts(fromCoordinates: coordinates)
        }
    }
}
