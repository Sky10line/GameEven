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
    private var draggablesList: [DraggableProtocol] = []
    private var backImage: SKSpriteNode?
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
      }
    
    override func didMove(to view: SKView) {
        //make Sprites
        
        let back = SKSpriteNode(color: .purple, size: CGSize(width: 160, height: 320))
    
        back.position = CGPoint(x: 0, y: 0)
        back.name = "silhouette"

        back.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 160, height: 320))

        if let bpb = back.physicsBody{
            bpb.categoryBitMask = 2
            bpb.collisionBitMask = 2
            bpb.contactTestBitMask = 1
            bpb.affectedByGravity = false
            bpb.isDynamic = false
            bpb.allowsRotation = false
            bpb.usesPreciseCollisionDetection = true
        }
        self.backImage = back
        self.addChild(back)
        
        for i in 0...1{
            let square = Square(image: "testeSpriteDrag", size: CGSize(width: 150, height: 150), pos: CGPoint(x: 0, y: 0), rotation: 0)
            square.insertCollider()
            self.draggablesList.insert(square, at: i)
            self.addChild(square.spriteNode!)
        }
        
        let triangle = Triangle(image: "triangleSprite", size: CGSize(width: 150, height: 150), pos: CGPoint(x: 0, y: 0), rotation: 0)
        triangle.insertCollider()
        self.draggablesList.insert(triangle, at: 0)
        self.addChild(triangle.spriteNode!)
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
        for i in self.draggablesList{
            print(i.checkInside(back: backImage!))
        }
        
        self.touchedNode = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchedNode = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


