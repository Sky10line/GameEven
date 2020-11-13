//
//  PartsReader.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 03/11/20.
//

import Foundation

struct PartsReader: Codable {
    let sprite: String
    let size: [Float]
    let pos: [Float]
    let rotation: Float
}
