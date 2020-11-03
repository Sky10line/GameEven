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
    
    private var touching = false
    private var touchPoint: CGPoint?
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        self.physicsWorld.contactDelegate = self
        
        //Pause Btt
        let pause = SKSpriteNode(
            color: .red,
            size: CGSize(width: 46, height: 46)
        )
        pause.name = "pause"
        pause.texture = SKTexture(imageNamed: "Button-X")
        pause.position.x = UIScreen.main.bounds.maxX / 2 - pause.size.width / 2 - 32
        pause.position.y = UIScreen.main.bounds.maxY / 2 - pause.size.height / 2 - ( safeAreaInsets().top == .zero ? 32 : safeAreaInsets().top)
        self.addChild(pause)
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
        self.draggablesList.insert(triangle, at: 2)
        self.addChild(triangle.spriteNode!)
        
        let circle = Circle(image: "circleSprite", size: CGSize(width: 150, height: 150), pos: CGPoint(x: 0, y: 0), rotation: 0)
        circle.insertCollider()
        self.draggablesList.insert(circle, at: 3)
        self.addChild(circle.spriteNode!)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let touchNodes = self.nodes(at: location)
            for node in touchNodes.reversed() {
                if node.name == "draggable" {
                    self.touchedNode = node as? SKSpriteNode
                    touchPoint = location
                    touching = true
                }
                if node.name == "pause" {
                    pauseGame()
                }
            }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        touchPoint = location
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if touching {
            if touchPoint != self.touchedNode?.position
            {
                let dt:CGFloat = 0.01
                let distance = CGVector(dx: touchPoint!.x-(self.touchedNode?.position.x)!, dy: touchPoint!.y-(self.touchedNode?.position.y)!)
                let vel = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
                self.touchedNode!.physicsBody!.velocity = vel
            }
        }
        else {
            self.touchedNode?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.touchedNode = nil
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        bodyA.velocity = CGVector(dx: 0, dy: 0)
        bodyB.velocity = CGVector(dx: 0, dy: 0)
    }
    
    private func safeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }
    
    func pauseGame(){
        let pauseMenu = PausePopUpView(size: CGSize(width: size.width - 64, height: size.height * 0.75))
        pauseMenu.pauseDelegate = self
        self.isPaused = true
        pauseMenu.zPosition = 1
        addChild(pauseMenu)
    }
}

extension GameScene: PauseMenuDelegate {
    func resumeLevel() {
        self.isPaused = false
    }
    
    func resetLevel() {
        
    }
    
    func exitLevel() {
        self.isPaused = false
    }
}

