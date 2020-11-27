//
//  Circle.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 29/10/20.
//

import UIKit
import GameplayKit

class Circle: Draggable {

    private var bBPointUp = SKNode()
    private var bBPointDown = SKNode()
    private var bBPointLeft = SKNode()
    private var bBPointRight = SKNode()
    
    private var pU: SKPhysicsBody!
    private var pD: SKPhysicsBody!
    private var pL: SKPhysicsBody!
    private var pR: SKPhysicsBody!
    
    override func insertCollider(){
        let node = self.spriteNode!
        
        node.addChild(bBPointUp)
        node.addChild(bBPointDown)
        node.addChild(bBPointLeft)
        node.addChild(bBPointRight)
        
        //create points on node
        self.correctPointPos()
        
        self.spriteNode?.physicsBody = SKPhysicsBody(circleOfRadius: self.spriteNode!.size.width/2)
        
        if let pb = self.spriteNode!.physicsBody{
            pb.categoryBitMask = 1
            pb.collisionBitMask = 9
            pb.contactTestBitMask = 9
            pb.affectedByGravity = false
            pb.isDynamic = true
            pb.allowsRotation = false
            pb.usesPreciseCollisionDetection = true
        }
        
        insertPointColider(sprite: bBPointUp, parent: node)
        insertPointColider(sprite: bBPointDown, parent: node)
        insertPointColider(sprite: bBPointLeft, parent: node)
        insertPointColider(sprite: bBPointRight, parent: node)
    }
    
    private func insertPointColider(sprite: SKNode,  parent: SKNode) {
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 2)
        
        if let pb = sprite.physicsBody{
            pb.categoryBitMask = 2
            pb.collisionBitMask = 0
            pb.contactTestBitMask = 16
            pb.affectedByGravity = false
            pb.isDynamic = true
            pb.allowsRotation = false
            pb.usesPreciseCollisionDetection = true
        }
    }
    
    override func correctPointPos(){
        bBPointUp.position = CGPoint(x:0, y: self.spriteNode!.size.height/2)
        bBPointDown.position = CGPoint(x: 0, y:-self.spriteNode!.size.height/2)
        bBPointLeft.position = CGPoint(x: -self.spriteNode!.size.width/2, y:0)
        bBPointRight.position = CGPoint(x: self.spriteNode!.size.width/2, y:0)
    }
    
    override func checkInside(back: SKNode, scene: SKNode) -> Bool{
        //convert points of the node to view points
        pU = bBPointUp.physicsBody
        pD = bBPointDown.physicsBody
        pL = bBPointLeft.physicsBody
        pR = bBPointRight.physicsBody
        
        
        if let backbodies = back.physicsBody?.allContactedBodies(){
            if(backbodies.contains(pU) && backbodies.contains(pD)){ //checa primeiro em cima e embaixo
                if(backbodies.contains(pL) && backbodies.contains(pR)){//depois os lados
                    return true
                }
            }
        }
        return false
    }

}
