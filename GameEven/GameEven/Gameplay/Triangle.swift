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
        
        self.spriteNode?.anchorPoint = CGPoint(x: width/1000, y:height/1000)
        
        let offsetX = -width/3.35;
        let offsetY = -height/3.35;
        
        points.insert(CGPoint(x: offsetX, y: offsetY), at: 0)
        points.insert(CGPoint(x: thirdPoint.x + offsetX, y: thirdPoint.y + offsetY), at: 1)
//        CGPoint(x: width/2 + offsetX, y: height + offsetY)
        points.insert(CGPoint(x: width + offsetX, y: offsetY), at: 2)
        
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
    
    func insertColliderManual(firstPoint: CGPoint, secondPoint: CGPoint, thirdPoint: CGPoint){
        
        let width = self.spriteNode!.size.width
        let height = self.spriteNode!.size.height
        
        let offsetX = -width/2;
        let offsetY = -height/2;
        
        points.insert(CGPoint(x: firstPoint.x + offsetX, y: firstPoint.y + offsetY), at: 0)
        points.insert(CGPoint(x: secondPoint.x + offsetX, y: secondPoint.y + offsetY), at: 1)
        points.insert(CGPoint(x: thirdPoint.x + offsetX, y: thirdPoint.y + offsetY), at: 2) 
        
        let path = CGMutablePath();
        
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addLine(to: points[2])

        path.closeSubpath()

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
    
    func checkInside(back: SKNode) -> Bool{
        let node = self.spriteNode!
        
        let firstPoint = CGPoint(x: node.position.x + points[0].x, y: node.position.y + points[0].y)
        let secondPoint = CGPoint(x: node.position.x + points[1].x, y: node.position.y + points[1].y)
        let thirdPoint = CGPoint(x: node.position.x + points[2].x, y: node.position.y + points[2].y)
        
        if(back.contains(firstPoint) && back.contains(secondPoint) && back.contains(thirdPoint)) { //checa primeiro em cima e embaixo
                return true
        }
        return false
    }
}
