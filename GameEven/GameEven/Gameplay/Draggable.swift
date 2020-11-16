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
            node.zRotation = CGFloat(GLKMathDegreesToRadians(Float(rotation)))
            
            //node.size = size
            
            print(self.spriteNode!.size.height)
            
            node.size.height = self.spriteNode!.size.height * 0.319
            node.size.width = self.spriteNode!.size.width * 0.319
            
            node.position = pos
            node.name = "draggable"
        }
    }
}
