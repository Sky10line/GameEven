//
//  Circle.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 29/10/20.
//

import UIKit
import GameplayKit

class Circle: Draggable, DraggableProtocol {
    private var bBPointUp = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private var bBPointDown = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private var bBPointLeft = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private var bBPointRight = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    
    private var pU: CGPoint!
    private var pD: CGPoint!
    private var pL: CGPoint!
    private var pR: CGPoint!
    
    func getName() -> String {
        return self.spriteNode!.name!
    }
    
    func getPos() -> CGPoint {
        return self.spriteNode!.position
    }
    
    func insertCollider(){
        let node = self.spriteNode!
        
        node.addChild(bBPointUp)
        node.addChild(bBPointDown)
        node.addChild(bBPointLeft)
        node.addChild(bBPointRight)
        
        //create points on node
        bBPointUp.position = CGPoint(x:0, y: node.size.height/2)
        bBPointDown.position = CGPoint(x: 0, y:-node.size.height/2)
        bBPointLeft.position = CGPoint(x: -node.size.width/2, y:0)
        bBPointRight.position = CGPoint(x: node.size.width/2, y:0)
        
        self.spriteNode?.physicsBody = SKPhysicsBody(circleOfRadius: self.spriteNode!.size.width/2)
        
        if let pb = self.spriteNode!.physicsBody{
            pb.categoryBitMask = 1
            pb.collisionBitMask = 1
            pb.contactTestBitMask = 1
            pb.affectedByGravity = false
            pb.isDynamic = true
            pb.allowsRotation = false
            pb.usesPreciseCollisionDetection = true
        }
    }
    
    func checkInside(back: SKNode, scene: SKNode) -> Bool{
        //convert points of the node to view points 
        pU = scene.convert(bBPointUp.position, from: self.spriteNode!)
        pD = scene.convert(bBPointDown.position, from: self.spriteNode!)
        pL = scene.convert(bBPointLeft.position, from: self.spriteNode!)
        pR = scene.convert(bBPointRight.position, from: self.spriteNode!)
        
        if(back.contains(pU) && back.contains(pD)){ //checa primeiro em cima e embaixo
            if(back.contains(pL) && back.contains(pR)){//depois os lados
                return true
            }
        }
        return false
    }
}
