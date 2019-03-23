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
    
    static func dictionary(fromFile name: String, ofType: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: ofType) else {
            throw EventsListError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw EventsListError.conversionFailure
        }
        
        return dictionary
    }
    
}

class EventsUnarchiver {
    static func eventsList(fromDictionary dictionary: [String: AnyObject]) -> [Event] {
        
        var eventsList: [Event] = []
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any],let year = itemDictionary["year"] as? String, let url = itemDictionary["url"] as? String {
                if let year = Int(year) {
                    let event = Event(title: key, year: Int(year), url: url)
                    eventsList.append(event)
                }
            }
        }
        return eventsList
    }
}
