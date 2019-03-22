//
//  Event.swift
//  BoutTime
//
//  Created by davidlaiymani on 21/03/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

struct Event: Comparable {
    let title: String
    let year: Int
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.year < rhs.year
    }
    
}
