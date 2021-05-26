//
//  Account.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 28/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import Foundation
import FXKeychain

class Account {
    
    static var words: [String]? {
        get {
            if let value = UserDefaults.standard.object(forKey: "words") as? [String] {
                return value
            }
            return nil
        }
    }
    
    static var sightWords: [String]? {
        get {
            if let value = UserDefaults.standard.object(forKey: "sightWords") as? [String] {
                return value
            }
            return nil
        }
    }
    
    static var allWords: [String] {
        var result = [String]()
        if let value = UserDefaults.standard.object(forKey: "sightWords") as? [String] {
            result.append(contentsOf: value)
        }
        if let value = UserDefaults.standard.object(forKey: "words") as? [String] {
            result.append(contentsOf: value)
        }
        return result
    }
    
    static var rewards: [String]? {
        get {
            if let value = UserDefaults.standard.object(forKey: "rewards") as? [String] {
                return value
            }
            return nil
        }
    }
    
    static var numberOfTokens: Int {
        get {
            if let value = UserDefaults.standard.value(forKey: "numberOfTokens") as? Int {
                return value
            }
            return 5
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "numberOfTokens")
            UserDefaults.standard.synchronize()
        }
    }
    
    static func addReward(_ word: String, picture: UIImage) -> Bool {
        var words = [String]()
        if let existingWords = self.rewards {
            words = existingWords
        }
        words.append(word)
        UserDefaults.standard.set(words, forKey: "rewards")
        UserDefaults.standard.synchronize()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var toURL = URL(string: "file://\(documentsPath)")!
        toURL = toURL.appendingPathComponent("/\(word).png")
        do {
            try picture.pngData()?.write(to: toURL)
        }
        catch {
            return false
        }
        return true
    }
    
    static func removeReward(_ word: String) -> Bool {
        var words = [String]()
        if let existingWords = self.rewards {
            words = existingWords
        }
        for (index, value) in words.enumerated() {
            if word == value {
                words.remove(at: index)
                UserDefaults.standard.set(words, forKey: "rewards")
                UserDefaults.standard.synchronize()
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                var picUrl = URL(string: "file://\(documentsPath)")!
                picUrl = picUrl.appendingPathComponent("/\(word).png")
                do {
                    if FileManager.default.fileExists(atPath: picUrl.path) == true {
                        try FileManager.default.removeItem(at: picUrl)
                    }
                }
                catch let error as NSError {
                    print(error)
                }
                return true
            }
        }
        return false
    }
    
    static func editReward(_ originalWord: String, newWord: String, picture: UIImage) {
        var words = [String]()
        if let existingWords = self.rewards {
            words = existingWords
        }
        for (index, value) in words.enumerated() {
            if originalWord == value {
                words[index] = newWord
                UserDefaults.standard.set(words, forKey: "rewards")
                UserDefaults.standard.synchronize()
                if Account.reward == originalWord {
                    Account.reward = newWord
                }
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                var picUrl = URL(string: "file://\(documentsPath)")!
                var newPicUrl = URL(string: "file://\(documentsPath)")!
                picUrl = picUrl.appendingPathComponent("/\(originalWord).png")
                newPicUrl = newPicUrl.appendingPathComponent("/\(newWord).png")
                do {
                    try picture.pngData()?.write(to: newPicUrl)
                    if FileManager.default.fileExists(atPath: picUrl.path) == true && originalWord != newWord {
                        try FileManager.default.removeItem(atPath: picUrl.path)
                    }
                }
                catch let error as NSError {
                    print(error)
                }
                return
            }
        }
    }
    
    static func addWord(_ word: String, picture: UIImage) -> Bool {
        var words = [String]()
        if let existingWords = self.words {
            words = existingWords
        }
        words.append(word)
        UserDefaults.standard.set(words, forKey: "words")
        UserDefaults.standard.synchronize()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var toURL = URL(string: "file://\(documentsPath)")!
        toURL = toURL.appendingPathComponent("/\(word).png")
        do {
            try picture.pngData()?.write(to: toURL)
        }
        catch {
            return false
        }
        return true
    }
    
    static func removeWord(_ word: String) -> Bool {
        var words = [String]()
        if let existingWords = self.words {
            words = existingWords
        }
        for (index, value) in words.enumerated() {
            if word == value {
                words.remove(at: index)
                UserDefaults.standard.set(words, forKey: "words")
                UserDefaults.standard.synchronize()
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                var picUrl = URL(string: "file://\(documentsPath)")!
                picUrl = picUrl.appendingPathComponent("/\(word).png")
                let soundUrl = Utils.documentsDirectory.appendingPathComponent("\(word).m4a")
                do {
                    if FileManager.default.fileExists(atPath: picUrl.path) == true {
                        try FileManager.default.removeItem(at: picUrl)
                    }
                    if FileManager.default.fileExists(atPath: soundUrl.path) == true {
                        try FileManager.default.removeItem(at: soundUrl)
                    }
                }
                catch let error as NSError {
                    print(error)
                }
                return true
            }
        }
        return false
    }
    
    static func editWord(_ originalWord: String, newWord: String, picture: UIImage) {
        var words = [String]()
        if let existingWords = self.words {
            words = existingWords
        }
        for (index, value) in words.enumerated() {
            if originalWord == value {
                words[index] = newWord
                UserDefaults.standard.set(words, forKey: "words")
                UserDefaults.standard.synchronize()
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                var picUrl = URL(string: "file://\(documentsPath)")!
                var newPicUrl = URL(string: "file://\(documentsPath)")!
                picUrl = picUrl.appendingPathComponent("/\(originalWord).png")
                newPicUrl = newPicUrl.appendingPathComponent("/\(newWord).png")
                do {
                    try picture.pngData()?.write(to: newPicUrl)
                    if FileManager.default.fileExists(atPath: picUrl.path) == true && originalWord != newWord {
                        try FileManager.default.removeItem(atPath: picUrl.path)
                    }
                }
                catch let error as NSError {
                    print(error)
                }
                return
            }
        }
    }
    
    static func addSightWords(_ word: String, picture: UIImage) -> Bool {
        var words = [String]()
        if let existingWords = self.sightWords {
            words = existingWords
        }
        words.append(word)
        UserDefaults.standard.set(words, forKey: "sightWords")
        UserDefaults.standard.synchronize()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var toURL = URL(string: "file://\(documentsPath)")!
        toURL = toURL.appendingPathComponent("/\(word).png")
        do {
            try picture.pngData()?.write(to: toURL)
        }
        catch {
            return false
        }
        return true
    }
    
    static func removeSightWords(_ word: String) -> Bool {
        var words = [String]()
        if let existingWords = self.sightWords {
            words = existingWords
        }
        for (index, value) in words.enumerated() {
            if word == value {
                words.remove(at: index)
                UserDefaults.standard.set(words, forKey: "sightWords")
                UserDefaults.standard.synchronize()
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                var picUrl = URL(string: "file://\(documentsPath)")!
                picUrl = picUrl.appendingPathComponent("/\(word).png")
                let soundUrl = Utils.documentsDirectory.appendingPathComponent("\(word).m4a")
                do {
                    if FileManager.default.fileExists(atPath: picUrl.path) == true {
                        try FileManager.default.removeItem(at: picUrl)
                    }
                    if FileManager.default.fileExists(atPath: soundUrl.path) == true {
                        try FileManager.default.removeItem(at: soundUrl)
                    }
                }
                catch let error as NSError {
                    print(error)
                }
                return true
            }
        }
        return false
    }
    
    static func editSightWords(_ originalSightWords: String, newSightWords: String, picture: UIImage) {
        var words = [String]()
        if let existingWords = self.sightWords {
            words = existingWords
        }
        for (index, value) in words.enumerated() {
            if originalSightWords == value {
                words[index] = newSightWords
                UserDefaults.standard.set(words, forKey: "sightWords")
                UserDefaults.standard.synchronize()
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                var picUrl = URL(string: "file://\(documentsPath)")!
                var newPicUrl = URL(string: "file://\(documentsPath)")!
                picUrl = picUrl.appendingPathComponent("/\(originalSightWords).png")
                newPicUrl = newPicUrl.appendingPathComponent("/\(newSightWords).png")
                do {
                    try picture.pngData()?.write(to: newPicUrl)
                    if FileManager.default.fileExists(atPath: picUrl.path) == true && newSightWords != originalSightWords {
                        try FileManager.default.removeItem(atPath: picUrl.path)
                    }
                }
                catch let error as NSError {
                    print(error)
                }
                return
            }
        }
    }
    
    static var name: String? {
        get {
            if let value = FXKeychain.default().object(forKey: "name") as? String {
                return value
            }
            return nil
        }
        set {
            FXKeychain.default().setObject(newValue, forKey: "name")
        }
    }
    
    static var reward: String? {
        get {
            if let value = UserDefaults.standard.object(forKey: "reward") as? String {
                return value
            }
            return nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "reward")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var photo: UIImage? {
        get {
            if let value = FXKeychain.default().object(forKey: "photo") as? Data {
                if let image = UIImage.init(data: value) {
                    return image
                }
            }
            return nil
        }
        set {
            var data: Data? = nil
            if let photo = newValue {
                if photo.size.width > 300.0 {
                    if let compressed = photo.resized(toWidth: 300.0) {
                        data = compressed.pngData()
                    }
                }
                else {
                    data = photo.pngData()
                }
            }
            FXKeychain.default().setObject(data, forKey: "photo")
        }
    }
    
    static var isHippoTraceOn: Bool {
        get {
            if UserDefaults.standard.object(forKey: "hippoTrace") != nil {
                return UserDefaults.standard.bool(forKey: "hippoTrace")
            }
            return true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hippoTrace")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var writerOption: Int {
        
        /*
         0 : type
         1 : trace with hippo
         2 : trace without hippo
         */
        
        get {
            if let value = UserDefaults.standard.value(forKey: "writerOption") as? Int {
                return value
            }
            return 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "writerOption")
            UserDefaults.standard.synchronize()
        }
    }
}
