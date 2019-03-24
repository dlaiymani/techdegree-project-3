//
//  GameManager.swift
//  BoutTime
//
//  Created by davidlaiymani on 22/03/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

class GameManager {
    
    var game: Game
    var numberOfRounds: Int
    var currentRound: Int
    var score: Int
    var eventsPerRound: Int
    var secondsPerRound: Int
    
    init(numberOfRounds: Int, eventsPerRound: Int, secondsPerRound: Int) {
        self.numberOfRounds = numberOfRounds
        self.eventsPerRound = eventsPerRound
        self.secondsPerRound = secondsPerRound
        game = Game(eventsPerRound: eventsPerRound)
        self.currentRound = 1
        self.score = 0
    }
    
    // Reinit the game for a new round
    func reinitGame() {
        self.game.events.removeAll()
        self.game = Game(eventsPerRound: eventsPerRound)
        self.score = 0
    }
    
    // Return a array of 4 events
    func randomEvent() -> [Event] {
        return game.events
    }
    
    // Check if a user answer is correct
    func checkEventOrder() -> Bool {
        
        return game.events.isSorted()

        
    }
}
