//
//  ArrayExtension.swift
//  BoutTime
//
//  Created by davidlaiymani on 22/03/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

// Array extension to check if an arry is sorted or not
extension Array where Element : Comparable {
    func isSorted() -> Bool {
        guard self.count > 1 else {
            return true
        }
        
        for i in 1..<self.count {
            if self[i-1] > self[i] {
                return false
            }
        }
        return true
    }
}
