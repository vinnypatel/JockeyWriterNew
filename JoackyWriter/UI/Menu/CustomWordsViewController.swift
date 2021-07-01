//
//  CustomWordsViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 03/03/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit
import AVFoundation

class CustomWordsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, AVAudioRecorderDelegate {
    
    var isSightWords = false
    var originalString: String?
    var string: String?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var recordLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var playButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player: AVPlayer?
    
    var audioFilePath: String {
        get {
            var filePath = Utils.documentsDirectory.appendingPathComponent("record.m4a").path
            if let existingString = originalString {
                filePath = Utils.documentsDirectory.appendingPathComponent("\(existingString).m4a").path
            }
            return filePath
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = originalString != nil ? "Edit \"\(originalString!)\"" : "Add"
        if let string = originalString {
            self.string = string
            wordLabel.text = string
            wordLabel.textColor = UIColor.darkBlue
            imageView.image = Utils.image(for: string)
            addButton.setTitle("Save", for: .normal)
            addButton.isEnabled = true
        }
        else {
            wordLabel.text = self.isSightWords == true ? "enter sight words" : "enter word"
            wordLabel.textColor = UIColor.darkBlue.withAlphaComponent(0.7)
        }
        imageView.layer.borderWidth = Utils.isPad ? 1.0 : 0.5
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.masksToBounds = true
        let rec = UITapGestureRecognizer.init(target: self,
                                              action: #selector(CustomWordsViewController.selectPhoto))
        imageView.addGestureRecognizer(rec)
        let rec2 = UITapGestureRecognizer.init(target: self,
                                              action: #selector(CustomWordsViewController.enterWord))
        wordLabel.addGestureRecognizer(rec2)
        if originalString != nil {
            setUpRecordStatus()
        }
        else {
            clear()
        }
    }
    
    // MARK: - Voice recording
    
    func setUpRecordStatus() {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: audioFilePath) {
            recordLabel.text = "Sound:"
            recordButton.isHidden = true
            deleteButton.isHidden = false
            playButton.isEnabled = true
        } else {
            recordLabel.text = "Hold microphone button to record sound:"
            recordButton.isHidden = false
            deleteButton.isHidden = true
            playButton.isEnabled = false
        }
    }
    
    func prepareForRecord() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSession.Category.record)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed == false {
                        self.recordLabel.text = "Voice recording unavailable"
                        self.recordButton.isEnabled = false
                        self.playButton.isEnabled = false
                    }
                }
            }
        }
        catch {
            self.recordLabel.text = "Voice recording unavailable"
            self.recordButton.isEnabled = false
            self.playButton.isEnabled = false
        }
    }
    
    func resetOutput() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSession.Category.ambient)
            try recordingSession.setActive(true)
        }
        catch {
            
        }
    }
    
    func clear() {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: audioFilePath)
        }
        catch {
            
        }
    }
    
    func save() {
        if let string = self.string {
            let fileManager = FileManager.default
            let destinationPath = Utils.documentsDirectory.appendingPathComponent("\(string).m4a").path
            
            do {
                if audioFilePath != destinationPath {
                    if fileManager.fileExists(atPath: destinationPath) {
                        try fileManager.removeItem(atPath: destinationPath)
                    }
                    try fileManager.moveItem(atPath: audioFilePath, toPath: destinationPath)
                }
            }
            catch let error {
                print(error)
            }
        }
    }
    
    @IBAction func record() {
        print("RECORD")
        Sounds.default.stopMusic()
        prepareForRecord()
        let audioFilename = URL.init(fileURLWithPath: audioFilePath)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            print("START")
        } catch {
            stop()
        }
    }
    
    @IBAction func stop() {
        print("STOP")
        audioRecorder.stop()
        audioRecorder = nil
        resetOutput()
    }
    
    @IBAction func play() {
        Sounds.default.stopMusic()
        let playerItem = AVPlayerItem.init(url: URL.init(fileURLWithPath: audioFilePath))
        self.player = AVPlayer.init(playerItem: playerItem)
        player?.volume = 1.0
        player?.play()
    }
    
    @IBAction func remove() {
        clear()
        setUpRecordStatus()
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        setUpRecordStatus()
        print("FINISH")
    }
    
    // MARK: -
    
    @IBAction func add() {
        var words = WordsViewController.defaultWords
        words.append(contentsOf: SentencesViewController.sentences)
        words.append(contentsOf: Account.allWords)
        if words.contains(string!) == true, string! != originalString {
            let alert = UIAlertController(title: nil, message: "\(string!) already exists", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if let editingString = originalString {
            if isSightWords == false {
                Account.editWord(editingString, newWord: string!, picture: imageView.image!)
            }
            else {
                Account.editSightWords(editingString, newSightWords: string!, picture: imageView.image!)
            }
            save()
            _ = self.navigationController?.popViewController(animated: true)
        }
        else {
            if isSightWords == false && Account.addWord(string!, picture: imageView.image!) {
                save()
                _ = self.navigationController?.popViewController(animated: true)
            }
            else if Account.addSightWords(string!, picture: imageView.image!) {
                save()
                _ = self.navigationController?.popViewController(animated: true)
            }
            else {
                let alert = UIAlertController(title: nil, message: "Oops! Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (_) in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.navigationController?.show(imagePicker, sender: self)
    }
    
    @objc func enterWord() {
        let message = self.isSightWords == true ? "Enter sight words" : "Enter word"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.string
            textField.delegate = self
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let text = alert?.textFields![0].text {
                if text.count > 0 {
                    self.string = text
                }
                else {
                    self.string = nil
                }
            }
            else {
                self.string = nil
            }
            if let string = self.string {
                self.wordLabel.text = string
                self.wordLabel.textColor = UIColor.darkBlue
                if self.imageView.image != nil {
                    self.addButton.isEnabled = true
                }
                else {
                    self.addButton.isEnabled = false
                }
            }
            else {
                self.wordLabel.text = self.isSightWords == true ? "enter sight words" : "enter word"
                self.wordLabel.textColor = UIColor.darkBlue.withAlphaComponent(0.7)
                self.addButton.isEnabled = false
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if pickedImage.size.width > 500.0 {
                if let compressed = pickedImage.resized(toWidth: 500.0) {
                    imageView.image = compressed
                    if string != nil {
                        self.addButton.isEnabled = true
                    }
                    else {
                        self.addButton.isEnabled = false
                    }
                }
            }
            else {
                imageView.image = pickedImage
                if string != nil {
                    self.addButton.isEnabled = true
                }
                else {
                    self.addButton.isEnabled = false
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var characters = "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        if isSightWords == true {
            characters.append(" ")
        }
        let set = NSCharacterSet(charactersIn: characters).inverted
        return string.rangeOfCharacter(from: set) == nil
    }
}
