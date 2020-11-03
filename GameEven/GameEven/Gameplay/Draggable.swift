//
//  Draggable.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 28/10/20.
//

import UIKit
import GameplayKit

class Draggable{
    var spriteNode: SKSpriteNode?
    
    init(image: String, size: CGSize, pos: CGPoint, rotation: CGFloat){
        self.spriteNode = SKSpriteNode(imageNamed: image)
        
        if let node = self.spriteNode{
            node.size = size
            node.position = pos
            node.name = "draggable"
            node.zRotation = rotation
        }
    }
}
