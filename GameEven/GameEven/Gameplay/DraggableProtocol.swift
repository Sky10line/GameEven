//
//  DraggableProtocol.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 28/10/20.
//

import Foundation
import GameplayKit

protocol DraggableProtocol {
    func insertCollider()
    func checkInside(back: SKNode) -> Bool
}
