//
//  SoundManager.swift
//  BoutTime
//
//  Created by davidlaiymani on 24/03/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import AudioToolbox


// Manage the sounds of the game
// Can do this with a unique function and a switch
struct SoundManager {
    
    static func playCorrectAnswerSound() {
        var gameSound: SystemSoundID = 0
        
        let path = Bundle.main.path(forResource: "CorrectDing", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
        AudioServicesPlaySystemSound(gameSound)
    }
    
    static func playIncorrectAnswerSound() {
        var gameSound: SystemSoundID = 0
        
        let path = Bundle.main.path(forResource: "IncorrectBuzz", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
        AudioServicesPlayAlertSound(gameSound)
    }
    
}
