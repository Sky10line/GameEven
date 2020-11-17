//
//  Square.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 27/10/20.
//

import UIKit
import GameplayKit

class Square: Draggable{
    
    private var bBPointUp = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private var bBPointDown = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private var bBPointLeft = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private var bBPointRight = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    
    private var pU: SKPhysicsBody!
    private var pD: SKPhysicsBody!
    private var pL: SKPhysicsBody!
    private var pR: SKPhysicsBody!
    
    override func insertCollider(pw: SKPhysicsWorld){
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
        
        self.spriteNode?.physicsBody = SKPhysicsBody(rectangleOf: self.spriteNode!.size)
        
        if let pb = self.spriteNode!.physicsBody{
            pb.categoryBitMask = UInt32(1)
            pb.collisionBitMask = UInt32(1)
            pb.contactTestBitMask = UInt32(1)
            pb.affectedByGravity = false
            pb.isDynamic = true
            pb.allowsRotation = false
            pb.usesPreciseCollisionDetection = true
        }
        
        insertPointColider(sprite: bBPointUp, parent: node, pw: pw)
        insertPointColider(sprite: bBPointDown, parent: node, pw: pw)
        insertPointColider(sprite: bBPointLeft, parent: node, pw: pw)
        insertPointColider(sprite: bBPointRight, parent: node, pw: pw)
    }
    
    private func insertPointColider(sprite: SKNode,  parent: SKNode, pw: SKPhysicsWorld) {
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 2)
        
        if let pb = sprite.physicsBody{
            pb.categoryBitMask = UInt32(16)
            pb.collisionBitMask = UInt32(16)
            pb.contactTestBitMask = UInt32(16)
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
            print(backbodies)
            if(backbodies.contains(pU) && backbodies.contains(pD)){ //checa primeiro em cima e embaixo
                print("Ponto em cima e baixo em contato")
                if(backbodies.contains(pL) && backbodies.contains(pR)){//depois os lados
                    return true
                }
            }
        }
        return false
    }

}
