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
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
      }
    
    override func didMove(to view: SKView) {
        //make Sprites
        for i in 1...4{
            let square = Square(image: "testeSpriteDrag", size: CGSize(width: 150, height: 150), pos: CGPoint(x: 150*i-375, y: -400))
            self.addChild(square.spriteNode!)
        }
       
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let touchNodes = self.nodes(at: location)
            for node in touchNodes.reversed() {
                if node.name == "draggable" {
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
    
    
}


