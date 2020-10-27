//
//  GameScene.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 26/10/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    private var touchedNode: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        //make sprites
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let touchNodes = self.nodes(at: location)
            for node in touchNodes.reversed() {
                if node.name == "arrastavel" {
                    self.touchedNode = node as? SKSpriteNode
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = self.touchedNode {
            let touchLocation =  touch.location(in: self)
            node.position = touchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        checkInside(back: ---Sprite Silhueta---, nodePos: ---.position da sprite que será encaixada---, nodeSize: ---.size da sprite que será encaixada---)
        self.touchedNode = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        checkInside(back: ---Sprite Silhueta---, nodePos: ---.position da sprite que será encaixada---, nodeSize: ---.size da sprite que será encaixada---)
        self.touchedNode = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func checkInsideSquare(back: SKNode, nodePos: CGPoint, nodeSize: CGSize) -> Bool{
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


