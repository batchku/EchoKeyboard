//
//  ContentView.swift
//  Echo Keyboard
//
//  Created by Ali Momeni on 1/11/23.
//


import AudioKit
import AudioKitUI
import AVFoundation
import Combine
import SwiftUI

struct DrumSample {
    var name: String
    var fileName: String
    var midiNote: Int
    var audioFile: AVAudioFile?
    var color = UIColor.red

    init(_ prettyName: String, file: String, note: Int) {
        name = prettyName
        fileName = file
        midiNote = note

        guard let url = Bundle.main.resourceURL?.appendingPathComponent(file) else { return }
        do {
            audioFile = try AVAudioFile(forReading: url)
            print("Reading file... " + file)
        } catch {
            Log("Could not load: \(fileName)")
        }
    }
}


class DrumsConductor: ObservableObject, HasAudioEngine {
    // Mark Published so View updates label on changes
    @Published private(set) var lastPlayed: String = "None"

    let engine = AudioEngine()
    
    let mixer = Mixer()
    
    var sounds: [String] = []
    let drumSamples: [DrumSample] =
        [
            
            DrumSample("OPEN HI HAT", file: "Samples/open_hi_hat_A#1.wav", note: 24),
            DrumSample("HI TOM", file: "Samples/hi_tom_D2.wav", note: 25),
            DrumSample("MID TOM", file: "Samples/mid_tom_B1.wav", note: 26),
            DrumSample("LO TOM", file: "Samples/lo_tom_F1.wav", note: 27),
            DrumSample("HI HAT", file: "Samples/closed_hi_hat_F#1.wav", note: 28),
            DrumSample("CLAP", file: "Samples/clap_D#1.wav", note: 29),
            DrumSample("SNARE", file: "Samples/snare_D1.wav", note: 30),
            DrumSample("KICK", file: "Samples/bass_drum_C1.wav", note: 31),
//            DrumSample("OPEN HI HAT", file: "Samples/echo_a-ball.wav", note: 31),
//            DrumSample("HI TOM", file: "Samples/echo_a-ball2.wav", note: 30),
//            DrumSample("MID TOM", file: "Samples/echo_ah1.wav", note: 29),
//            DrumSample("LO TOM", file: "Samples/echo_ah2.wav", note: 28),
//            DrumSample("HI HAT", file: "Samples/echo_anana.wav", note: 27),
//            DrumSample("CLAP", file: "Samples/echo_a-ball2.wav", note: 26),
//            DrumSample("SNARE", file: "Samples/echo_aqua.wav", note: 25),
//            DrumSample("KICK", file: "Samples/echo_aqua2.wav", note: 24),
//            DrumSample("KICK", file: "Samples/echo_aqua2.wav", note: 60),
//            DrumSample("DID", file: "Samples/echo_i-did-that2.wav", note: 61),
//            DrumSample("CHOO", file: "Samples/echo_choo-choo.wav", note: 62)
            
            
        ]
    

    let drums = AppleSampler()

    func soundFileList() {
        // Build audio file name list
        let fileNameExtension = ".wav"
        if let files = try? FileManager.default.contentsOfDirectory(atPath: Bundle.main.bundlePath + "/Samples" ){
            for file in files {
                if file.hasSuffix(fileNameExtension) {
                    let name = file.prefix(file.count - fileNameExtension.count)
                    sounds.append(String(name))
                }
            }
        }
        print(sounds)

    }
    
    func playPad(padNumber: Int) {
        //drums.play(noteNumber: MIDINoteNumber(drumSamples[padNumber].midiNote))
        let noteToPlay = Int.random(in: 24..<32)
        drums.play(noteNumber: MIDINoteNumber(noteToPlay))
        print("Playing note... " + String(noteToPlay))
//        let fileName = drumSamples[noteToPlay-60].fileName
//        lastPlayed = fileName.components(separatedBy: "/").last!
    }

    init() {
        soundFileList()
        engine.output = drums
        do {
            let files = drumSamples.map {
                $0.audioFile!
            }
            try drums.loadAudioFiles(files)
            print("Loading sample into sampler... ")

        } catch {
            Log("Files Didn't Load")
        }
        

    }
}

struct ContentView: View {
    @StateObject var conductor = DrumsConductor()

    var body: some View {
        VStack {
            Text("Echo")
                .bold()
                .font(.system(size: 48.0))
                .onTapGesture {
                    conductor.playPad(padNumber: 1)
                }
                .padding()
        }
        .onAppear {
            conductor.start()
        }
        .onDisappear {
            conductor.stop()
        }
    }
}
