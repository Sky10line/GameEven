//
//  lvlReader.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 03/11/20.
//

import Foundation

struct lvlReader: Codable{
    let instruction: String
    let silhouette: PartsReader
    let squares: [PartsReader]
    let triangles: [TrianglePartsReader]
    let circles: [PartsReader]
}
