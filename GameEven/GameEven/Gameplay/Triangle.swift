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
        
//        self.spriteNode?.anchorPoint = CGPoint(x: width/1000, y:height/1000)
        
        let offsetX = -width/2;
        let offsetY = -height/2;
        
        points.insert(CGPoint(x: offsetX, y: offsetY), at: 0)
        points.insert(CGPoint(x: thirdPoint.x + offsetX, y: thirdPoint.y + offsetY), at: 1)
//        CGPoint(x: width/2 + offsetX, y: height + offsetY)
        points.insert(CGPoint(x: width + offsetX, y: offsetY), at: 2)
        
        let node = self.spriteNode!
        
        node.addChild(firstPoint)
        node.addChild(secondPoint)
        node.addChild(thirdPoint1)
        
        //create points on node
        firstPoint.position = CGPoint(x: points[0].x, y: points[0].y)
        secondPoint.position = CGPoint(x: points[1].x, y: points[1].y)
        thirdPoint1.position = CGPoint(x: points[2].x, y: points[2].y)
        
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
