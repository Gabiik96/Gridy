//
//  SoundManager.swift
//  Gridy
//
//  Created by Gabriel Balta on 14/04/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class SoundManager {
    let squareInSound = URL(fileURLWithPath: Bundle.main.path(forResource: "In", ofType: "m4a")!)
    let squareOutSound = URL(fileURLWithPath: Bundle.main.path(forResource: "Out", ofType: "m4a")!)
    let clapSound = URL(fileURLWithPath: Bundle.main.path(forResource: "Clap", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    var sTimer: Timer?
    
    func playSound(_ sound: URL,_ speakerBtn: UIButton) {
        if speakerBtn.imageView?.image == UIImage(systemName: "speaker.2.fill") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: sound)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func soundWithTimer(interval: TimeInterval, sound: URL, speakerBtn: UIButton) {
        self.playSound(sound, speakerBtn)
        guard sTimer == nil else { return }
        sTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            self.playSound(sound, speakerBtn)
        }
        sTimer!.fire()
    }
    
    func stopPlayingSounds(timer: Timer?) {
        audioPlayer.stop()
        guard sTimer != nil  else { return }
        self.sTimer?.invalidate()
    }
}
