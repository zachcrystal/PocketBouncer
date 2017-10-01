//
//  Sound.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-13.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

/*
import UIKit
import AVFoundation

class Sound: AVPlayer {
    
    var audioPlayer: AVAudioPlayer?
    
    func playMusic() {
        guard let sound = NSDataAsset(name: "MusicLoop3") else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            
            audioPlayer!.play()
            audioPlayer!.numberOfLoops = -1
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func stopAudio() {
        if audioPlayer != nil {
            audioPlayer?.stop()
            audioPlayer = nil
        }
    }
}
*/
