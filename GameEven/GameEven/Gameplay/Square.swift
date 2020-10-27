//
//  Square.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 27/10/20.
//

import UIKit
import GameplayKit

class Square {
    var spriteNode: SKSpriteNode?
    
    init(image: String, size: CGSize, pos: CGPoint){
        self.spriteNode = SKSpriteNode(imageNamed: image)
        
        if let node = self.spriteNode{
            node.size = size
            node.position = pos
            node.name = "draggable"
            node.physicsBody = SKPhysicsBody(rectangleOf: size)
        
            if let pb = node.physicsBody{
                pb.categoryBitMask = 1
                pb.collisionBitMask = 1
                pb.contactTestBitMask = 1
                pb.affectedByGravity = false
                pb.isDynamic = true
                pb.allowsRotation = false
                pb.usesPreciseCollisionDetection = true
            }
        }
    }
    
    func checkInsideSquare(back: SKNode) -> Bool{
        let nodeSize = self.spriteNode!.size
        let nodePos = self.spriteNode!.position
        
        let bBPointUp = CGPoint(x:nodePos.x, y:(nodePos.y + (nodeSize.height/2))) //monta um ponto na aresta de cima da sprite que está sendo encaixada
        let bBPointDown = CGPoint(x: nodePos.x, y:(nodePos.y - (nodeSize.height/2)))//monta um ponto na aresta de baixo da sprite que está sendo encaixada
        let bBPointLeft = CGPoint(x: (nodePos.x - (nodeSize.width/2)), y:nodePos.y)//monta um ponto na aresta da esquerda da sprite que está sendo encaixada
        let bBPointRight = CGPoint(x: (nodePos.x + (nodeSize.width/2)), y:nodePos.y)//monta um ponto na aresta da direita da sprite que está sendo encaixada
        
        if(back.contains(bBPointUp) && back.contains(bBPointDown)){ //checa primeiro em cima e embaixo
            if(back.contains(bBPointLeft) && back.contains(bBPointRight)){//depois os lados
                return true
            }
        }
        return false
    }

}
