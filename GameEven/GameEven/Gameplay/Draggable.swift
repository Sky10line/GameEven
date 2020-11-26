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
    var scale: CGFloat!
    var decreased = false
    init(image: String, pos: CGPoint, rotation: CGFloat, imageScale: CGFloat){
        self.spriteNode = SKSpriteNode(imageNamed: image)
        
        scale = imageScale * CGFloat(0.925)

        if let node = self.spriteNode{
            node.zRotation = CGFloat(GLKMathDegreesToRadians(Float(rotation)))
            node.size.height = self.spriteNode!.size.height * CGFloat(scale!)
            node.size.width = self.spriteNode!.size.width * CGFloat(scale!)
            if node.size.height <= 44 && node.size.width <= 44 {
                print("ERRO \n ERRO \n \(node.size) \n ERRO \n ERRO")
            }
            
            node.position = pos
            node.name = "draggable"
        }
    }
    
    init(drag: Draggable) {
        self.spriteNode = drag.spriteNode
        self.scale = drag.scale
    }
    
    func correctPointPos(){
    }
    
    func insertCollider(){
        
    }
    
    func insertPartCollider(){
        
    }
    
    func isDecreased() -> Bool{
        return decreased 
    }
    
    func decrease(){
    }
    
    func increase(){

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
