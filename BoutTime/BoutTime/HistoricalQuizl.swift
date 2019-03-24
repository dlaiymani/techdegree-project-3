//
//  TestProtocol.swift
//  BoutTime
//
//  Created by davidlaiymani on 24/03/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import GameKit

protocol Question {
    var title: String { get }
}

// Fact implements Question and Comparable
struct Fact: Question, Comparable {
    var title: String
    var year: Int
    var url: String
    
    static func < (lhs: Fact, rhs: Fact) -> Bool {
        return lhs.year < rhs.year
    }
}

protocol Quiz {
    var questionsSet: [Fact] { get }
    var questionsForRound: [Fact] { get }
    var numberOfQuestionsPerRound: Int { get}
    var numberOfRounds: Int { get }
    var secondsPerRound: Int { get }

    init(numberOfQuestionsPerRound: Int, numberOfRounds: Int, secondsPerRound : Int)
    
    // Return a random array of Fact objects
    func randomQuestion() -> [Fact]
    
    // Re-init a quiz
    func reinitQuiz()
    
    // Check if a user answer is correct
    func checkUserAnswer() -> Bool

}

// An HistoricalQuiz is a Quiz
class HistoricalQuiz: Quiz {
    
    var questionsSet: [Fact]
    var questionsForRound: [Fact]
    var numberOfQuestionsPerRound: Int
    var numberOfRounds: Int
    var secondsPerRound: Int

    var currentRound: Int
    var score: Int
    
    
    required init(numberOfQuestionsPerRound: Int, numberOfRounds: Int, secondsPerRound : Int) {
        self.numberOfQuestionsPerRound = numberOfQuestionsPerRound
        self.questionsSet = [Fact]()
        self.questionsForRound = [Fact]()
        self.numberOfRounds = numberOfRounds
        self.secondsPerRound = secondsPerRound
        self.currentRound = 1
        self.score = 0
        
        // Load the events from a plist file
        do {
            let dictionary = try PlistConverter.dictionary(fromFile: "Event", ofType: "plist")
            self.questionsSet = FactsUnarchiver.factsList(fromDictionary: dictionary)
            
        } catch let error {
            fatalError("\(error)")
        }
        createRound()
    }
    
    // Create a new round by ensuring duplicate questions in the quiz.
    func createRound() {
        var alreadyChoosenQuestions = [Int]()
        for _ in 0..<numberOfQuestionsPerRound {
            var randomNumber = 0
            repeat {
                randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: questionsSet.count)
            } while alreadyChoosenQuestions.index(where: {$0 == randomNumber}) != nil
            alreadyChoosenQuestions.append(randomNumber)
            
            self.questionsForRound.append(questionsSet[randomNumber])
        }
        
    }
    
    // Reinit the game for a new round
    func reinitQuiz() {
        self.questionsForRound.removeAll()
        createRound()
    }
    
    // Return a array of 4 events
    func randomQuestion() -> [Fact] {
        return questionsForRound
    }
    
    // Check if a user answer is correct
    func checkUserAnswer() -> Bool {
        return questionsForRound.isSorted()
    }
    
}

// Possible error when lodaing the model (plist file)
enum FactsListError: Error {
    case invalidResource
    case conversionFailure
}

// Convert a .plist file and transform it into a dictionnary
class PlistConverter {
    static func dictionary(fromFile name: String, ofType: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: ofType) else {
            throw FactsListError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw FactsListError.conversionFailure
        }
        
        return dictionary
    }
}

// Convert a dictionnary into an array of Event objects
class FactsUnarchiver {
    static func factsList(fromDictionary dictionary: [String: AnyObject]) -> [Fact] {
        
        var factsList: [Fact] = []
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any],let year = itemDictionary["year"] as? String, let url = itemDictionary["url"] as? String {
                if let year = Int(year) {
                    let fact = Fact(title: key, year: Int(year), url: url)
                    factsList.append(fact)
                }
            }
        }
        return factsList
    }
}
