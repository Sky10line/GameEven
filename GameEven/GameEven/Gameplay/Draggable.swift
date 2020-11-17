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
        
        let scale = 0.319
        
        if let node = self.spriteNode{
            node.zRotation = CGFloat(GLKMathDegreesToRadians(Float(rotation)))
            
            node.size.height = self.spriteNode!.size.height * CGFloat(scale)
            node.size.width = self.spriteNode!.size.width * CGFloat(scale)
            
            node.position = pos
            node.name = "draggable"
        }
    }
    
    func correctPointPos(){
    }
    
    func insertCollider(pw: SKPhysicsWorld){
        
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
