//
//  Triangle.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 28/10/20.
//

import UIKit
import GameplayKit

class Triangle: Draggable, DraggableProtocol{
    private var path: CGPath?
    private var points: [CGPoint] = []
    private var thirdPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    private let firstPoint = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private let secondPoint = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    private let thirdPoint1 = SKSpriteNode(color: .red, size: CGSize(width: 4, height: 4))
    
    private var p1: CGPoint!
    private var p2: CGPoint!
    private var p3: CGPoint!
    
    func getName() -> String {
        return self.spriteNode!.name!
    }
    
    func getPos() -> CGPoint {
        return self.spriteNode!.position
    }
    
    func setThirdPoint(Point: CGPoint){
        self.thirdPoint = Point
    }
    
    func insertCollider(){
        let width = self.spriteNode!.size.width
        let height = self.spriteNode!.size.height

        let offsetX = -width/2;
        let offsetY = -height/2;

        let node = self.spriteNode!
        
        node.addChild(firstPoint)
        node.addChild(secondPoint)
        node.addChild(thirdPoint1)
        
        //create points on node
        firstPoint.position = CGPoint(x: offsetX, y: offsetY)
        secondPoint.position = CGPoint(x: offsetX, y: offsetY * (-1))
        thirdPoint1.position = CGPoint(x: offsetX * (-1), y: offsetY)
        
        self.spriteNode?.physicsBody = SKPhysicsBody(texture: self.spriteNode!.texture!, size: self.spriteNode!.size)
        
        if let pb = self.spriteNode?.physicsBody {
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
        p1 = scene.convert(firstPoint.position, from: self.spriteNode!)
        p2 = scene.convert(secondPoint.position, from: self.spriteNode!)
        p3 = scene.convert(thirdPoint1.position, from: self.spriteNode!)
        
        if(back.contains(p1) && back.contains(p2) && back.contains(p3)) { //checa primeiro em cima e embaixo
                return true
        }
        return false
    }
}
