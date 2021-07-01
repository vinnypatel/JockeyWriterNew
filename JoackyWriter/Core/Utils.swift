//
//  Utils.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 13/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class Utils {
    
    // App key and secret
    static let fullDropboxAppKey = "lct52txb52nixo0"
    static let fullDropboxAppSecret = "f2syk4j80wttqr5"
    
    static var isPad: Bool {
        get {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
    }
    
    static var letterFontSize: CGFloat {
        get {
            if isPad {
                return 540
            }
            return 300
        }
    }
    
    static var isLandscapeMode: Bool {
        get {
            return UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
        }
    }
    
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func image(for word: String) -> UIImage? {
        if let image = UIImage.init(named: word) {
            return image
        }
        else {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            var fileURL = URL(string: "file://\(documentsPath)")!
            fileURL = fileURL.appendingPathComponent("/\(word).png")
            let image = UIImage(contentsOfFile: fileURL.path)
            return image
        }
    }
    
    static func parts(fromCoordinates coordinates: [[(CGFloat, CGFloat)]]) -> [Part] {
        var coordinates = coordinates
        if Utils.isPad == true {
            var tmp = [[(CGFloat, CGFloat)]]()
            for array in coordinates {
                let converted = array.map { item -> ((CGFloat, CGFloat)) in
                    var newItem: (CGFloat, CGFloat) = (0, 0)
                    newItem.0 = item.0 * 1.8
                    newItem.1 = item.1 * 1.8
                    return newItem
                }
                tmp.append(converted)
            }
            coordinates = tmp
        }
        
        var result = [Part]()
        for coordinatesArray in coordinates {
            var trace = [CGPoint]()
            for coordinatesItem in coordinatesArray {
                trace.append(CGPoint.init(x: coordinatesItem.0, y: coordinatesItem.1))
            }
            
            result.append(Part.init(trace: trace))
        }
        return result
    }
    
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays) as Date
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours) as Date
        
        //Return Result
        return dateWithHoursAdded
    }
}
