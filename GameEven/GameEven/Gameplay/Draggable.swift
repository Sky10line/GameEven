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
    
    init(image: String, pos: CGPoint, rotation: CGFloat, imageScale: CGFloat){
        self.spriteNode = SKSpriteNode(imageNamed: image)
        
        let percentageScaleAdjust = CGFloat(0.925) // Porcentagem de quanto vai diminuir a peça além da escala já atribuída.
        let scale = imageScale * percentageScaleAdjust
        
        if let node = self.spriteNode{
            node.zRotation = CGFloat(GLKMathDegreesToRadians(Float(rotation)))
            
            node.size.height = self.spriteNode!.size.height * CGFloat(scale)
            node.size.width = self.spriteNode!.size.width * CGFloat(scale)
            
            node.position = pos
            node.name = "draggable"
        }
    }
    
    init(drag: Draggable) {
        self.spriteNode = drag.spriteNode
    }
    
    func correctPointPos(){
    }
    
    func insertCollider(){
        
    }
    func checkInside(back: SKNode, scene: SKNode) -> Bool{
        return false
    }
    func getName() -> String{
        return (self.spriteNode?.name)!
    }
    func getPos() -> CGPoint
    {
        return self.spriteNode!.position
    }
}
