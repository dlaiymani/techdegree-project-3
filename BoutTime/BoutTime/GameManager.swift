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
    
    init(numberOfRounds: Int) {
        self.numberOfRounds = numberOfRounds
        game = Game(eventsPerRound: 4)
        self.currentRound = 1
    }
    
    // Reinit the game for a new round
    func reinitGame() {
        self.game.events.removeAll()
        self.game = Game(eventsPerRound: 4)
        self.currentRound = 1
    }
    
    // Return a array of 4 events
    func randomEvent() -> [Event] {
        return game.events
    }
    
    // FIXME:  Check if a user answer is correct
    func checkEventOrder() -> Bool {
        
        return game.events.isSorted()

        
    }
}
