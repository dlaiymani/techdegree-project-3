//
//  Game.swift
//  BoutTime
//
//  Created by davidlaiymani on 21/03/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import GameKit


class Game {
    var eventsSet: [Event]
    var events: [Event]
    var eventsPerRound: Int
    
    init(eventsPerRound: Int) {
        
        self.eventsPerRound = eventsPerRound
        self.events = [Event]()
        
        // Load the events from a plist file
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "Event", ofType: "plist")
            self.eventsSet = EventsUnarchiver.eventsList(fromDictionary: dictionary)
            
        } catch let error {
            fatalError("\(error)")
        }
        
        // Create a round
        // Ensure no duplicate questions in the quiz.
        var alreadyChoosenEvent = [Int]()
        for _ in 0..<eventsPerRound {
            var randomNumber = 0
            repeat {
                randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: eventsSet.count)
            } while alreadyChoosenEvent.index(where: {$0 == randomNumber}) != nil
            alreadyChoosenEvent.append(randomNumber)
            
            self.events.append(eventsSet[randomNumber])
        }
    }
    
}
