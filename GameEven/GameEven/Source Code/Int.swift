//
//  Int.swift
//  GameEven
//
//  Created by Rogerio Lucon on 26/11/20.
//

import Foundation

extension Int {
    func intToTime() -> String {
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: self)
        return "\(String(format: "%02d", h)) : \(String(format: "%02d", m)) : \(String(format: "%02d", s))"
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
