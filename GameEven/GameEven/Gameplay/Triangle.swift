//
//  Triangle.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 28/10/20.
//

import UIKit
import GameplayKit

class Triangle: Draggable{
    private var path: CGPath?
    private var points: [CGPoint] = []
    private var thirdTrianglePoint: CGFloat = 0
    
    private let firstPoint = SKSpriteNode(color: .red, size: CGSize(width: 8, height: 8))
    private let secondPoint = SKSpriteNode(color: .red, size: CGSize(width: 8, height: 8))
    private let thirdPoint = SKSpriteNode(color: .red, size: CGSize(width: 8, height: 8))
    
    private var p1: SKPhysicsBody!
    private var p2: SKPhysicsBody!
    private var p3: SKPhysicsBody!
    
    func setThirdPoint(Point: CGFloat){
        self.thirdTrianglePoint = Point
    }
    
    override func insertCollider(pw: SKPhysicsWorld){
        let width = self.spriteNode!.size.width
        let height = self.spriteNode!.size.height
        
        let scale = Float(self.spriteNode!.size.height) / Float(self.spriteNode!.texture!.cgImage().height)

        let offsetX = -width/2;
        let offsetY = -height/2;
        
        points.insert(CGPoint(x: offsetX, y: offsetY), at: 0)
        points.insert(CGPoint(x: offsetX * (-1), y: offsetY), at: 1)
        points.insert(CGPoint(x: CGFloat(Float(thirdTrianglePoint) * scale) + offsetX, y: offsetY * (-1)), at: 2)

        let node = self.spriteNode!
        
        node.addChild(firstPoint)
        node.addChild(secondPoint)
        node.addChild(thirdPoint)
        
        //create points on node
        firstPoint.position = CGPoint(x: points[0].x, y: points[0].y)
        secondPoint.position = CGPoint(x: points[1].x, y: points[1].y)
        thirdPoint.position = CGPoint(x: points[2].x, y: points[2].y)
        
        let path = CGMutablePath();

        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addLine(to: points[2])

        path.closeSubpath()
        self.path = path
        
        self.spriteNode?.physicsBody = SKPhysicsBody(polygonFrom: path)
        
        if let pb = self.spriteNode?.physicsBody {
            pb.categoryBitMask = 1
            pb.collisionBitMask = 1
            pb.contactTestBitMask = 1
            pb.affectedByGravity = false
            pb.isDynamic = true
            pb.allowsRotation = false
            pb.usesPreciseCollisionDetection = true
        }
        
        insertPointColider(sprite: firstPoint, parent: node, pw: pw)
        insertPointColider(sprite: secondPoint, parent: node, pw: pw)
        insertPointColider(sprite: thirdPoint, parent: node, pw: pw)
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
        //create points on node
        firstPoint.position = CGPoint(x: points[0].x, y: points[0].y)
        secondPoint.position = CGPoint(x: points[1].x, y: points[1].y)
        thirdPoint.position = CGPoint(x: points[2].x, y: points[2].y)
    }
    
    override func checkInside(back: SKNode, scene: SKNode) -> Bool{
        //convert points of the node to view points 
        p1 = firstPoint.physicsBody
        p2 = secondPoint.physicsBody
        p3 = thirdPoint.physicsBody
        
        if let backbodies = back.physicsBody?.allContactedBodies(){
            if(backbodies.contains(p1) && backbodies.contains(p2) && backbodies.contains(p3)) { //checa primeiro em cima e embaixo
                    return true
            }
        }
        return false
    }
}
