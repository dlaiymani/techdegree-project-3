//
//  PlistManager.swift
//  BoutTime
//
//  Created by davidlaiymani on 21/03/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

enum EventsListError: Error {
    case invalidResource
    case conversionFailure
    case invalidSelection
}

class PlistConverter {
    
    static func dictionary(fromFile name: String, ofType: String) throws -> [String: String] {
        guard let path = Bundle.main.path(forResource: name, ofType: ofType) else {
            throw EventsListError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] else {
            throw EventsListError.conversionFailure
        }
        
        return dictionary
    }
    
}

class EventsUnarchiver {
    static func eventsList(fromDictionary dictionary: [String: String]) -> [Event] {
        
        var eventsList: [Event] = []
        for (key, value) in dictionary {
            if let year = Int(value) {
                let event = Event(title: key, year: year)
                eventsList.append(event)
            }
        }
        return eventsList
    }
}
