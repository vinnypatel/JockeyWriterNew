//
//  Sounds.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 03/03/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import Foundation
import AVFoundation

class Sounds {
    
    static var `default` = Sounds()
    
    var speakPlayer: AVPlayer?
    var traceSound: AVAudioPlayer?
    var partCompletedSound: AVAudioPlayer?
    var successSound: AVAudioPlayer?
    var backgroundMusic: AVAudioPlayer?
    
    func prepare() {
        let traceUrl = Bundle.main.url(forResource: "trace", withExtension: "wav")!
        do {
            traceSound = try AVAudioPlayer(contentsOf: traceUrl)
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        let musicUrl = Bundle.main.url(forResource: "background", withExtension: "mp3")!
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: musicUrl)
            backgroundMusic?.numberOfLoops = -1
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        let correctTracingUrl = Bundle.main.url(forResource: "correct_tracing", withExtension: "wav")!
        do {
            partCompletedSound = try AVAudioPlayer(contentsOf: correctTracingUrl)
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        let successUrl = Bundle.main.url(forResource: "success", withExtension: "wav")!
        do {
            successSound = try AVAudioPlayer(contentsOf: successUrl)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func speak(_ text: String) {
        let audioFilename = Utils.documentsDirectory.appendingPathComponent("\(text).m4a")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: audioFilename.path) {
            let playerItem = AVPlayerItem.init(url: audioFilename)
            speakPlayer = AVPlayer.init(playerItem: playerItem)
            speakPlayer?.volume = 1.0
            speakPlayer?.play()
        }
        else {
            let utterance = AVSpeechUtterance(string: text)
            let synth = AVSpeechSynthesizer()
            synth.speak(utterance)
        }
    }
    
    func playTraceSound() {
        traceSound?.prepareToPlay()
        traceSound?.play()
    }
    
    func playPartCompletedSound() {
        partCompletedSound?.prepareToPlay()
        partCompletedSound?.play()
    }
    
    func playSuccessSound() {
        successSound?.prepareToPlay()
        successSound?.play()
    }
    
    func playMusic() {
        
        self .stopMusic()
        
        /*
        if let music = backgroundMusic {
            if music.isPlaying == true {
                return
            }
        }
        backgroundMusic?.prepareToPlay()
        backgroundMusic?.play()
        */
    }
    
    func stopMusic() {
        backgroundMusic?.stop()
    }
}
