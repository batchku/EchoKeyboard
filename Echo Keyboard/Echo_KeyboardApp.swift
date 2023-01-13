//
//  Echo_KeyboardApp.swift
//  Echo Keyboard
//
//  Created by Ali Momeni on 1/11/23.
//


import AudioKit
import AudioKitUI
import AVFoundation
//import CookbookCommon
import SwiftUI

@main
struct Echo_KeyboardApp: App {
    
    init() {
        #if os(iOS)
            do {
                Settings.bufferLength = .short
                try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                                options: [.defaultToSpeaker, .mixWithOthers, .allowBluetoothA2DP])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let err {
                print(err)
            }
        #endif
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
