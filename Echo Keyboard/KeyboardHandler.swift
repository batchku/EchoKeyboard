//
//  KeyboardHandler.swift
//  Echo Keyboard
//
//  Created by Ali Momeni on 1/11/23.
//

import Foundation
import UIKit
import AVFoundation
import AudioKit

class KeyboardHandler: UIViewController {
    
    
    // Find audio files in app resources
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    var sounds: [String] = []
    
    // For audio playback
    let engine = AudioEngine()
    let player = AudioPlayer()
    let mixer = Mixer()
    

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else { return }
        let thisKey = key.keyCode.rawValue
        let thisSound = sounds[thisKey % sounds.count]
        player.stop()
        playSound(soundName: thisSound)
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        let randomSound = sounds.randomElement()
        playSound(soundName: randomSound!)
    }
    
    
    func playSound(soundName: String) {
        
        let url = Bundle.main.url(forResource: soundName, withExtension: "wav")
        
        let randomSoundFile = try! AVAudioFile(forReading: url!)
        player.scheduleFile(randomSoundFile, at: nil)
        player.play()
                
    }
}

