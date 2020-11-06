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
    private var win = false
    public var level: Int = 1
    
    private var touching = false
    private var touchPoint: CGPoint?
    private var touchDistToCenter: CGPoint?
    
    private var pause: SKSpriteNode!
    
    var viewControllerDelegate: PopViewControllerDelegate?
    
    override func didMove(to view: SKView) {
        //make Sprites
        self.physicsWorld.contactDelegate = self
        
        //Pause Btt
        pause = SKSpriteNode(
            color: .red,
            size: CGSize(width: 46, height: 46)
        )
        pause.name = "pause"
        pause.texture = SKTexture(imageNamed: "Button-Pause")
        pause.position.x = UIScreen.main.bounds.maxX / 2 - pause.size.width / 2 - 32
        pause.position.y = UIScreen.main.bounds.maxY / 2 - pause.size.height / 2 - ( safeAreaInsets().top == .zero ? 32 : safeAreaInsets().top)
        self.addChild(pause)
        
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
        
        let lvl: lvlReader = load("lvl\(level).json")
        
        for square in lvl.squares{
            let size = CGSize(width: CGFloat(square.size[0]), height: CGFloat(square.size[1]))
            let pos = CGPoint(x: CGFloat(square.pos[0]), y: CGFloat(square.pos[1]))
            let rot = CGFloat(square.rotation)
            let part = Square(image: square.sprite, size: size, pos: pos, rotation: rot)
            
            part.insertCollider()
            self.draggablesList.append(part)
            self.addChild(part.spriteNode!)
        }
        
        for triangle in lvl.triangles{
            let size = CGSize(width: CGFloat(triangle.size[0]), height: CGFloat(triangle.size[1]))
            let pos = CGPoint(x: CGFloat(triangle.pos[0]), y: CGFloat(triangle.pos[1]))
            let rot = CGFloat(triangle.rotation)
            let part = Triangle(image: triangle.sprite, size: size, pos: pos, rotation: rot)
            
            part.insertCollider()
            self.draggablesList.append(part)
            self.addChild(part.spriteNode!)
        }
        
        for circle in lvl.circles{
            let size = CGSize(width: CGFloat(circle.size[0]), height: CGFloat(circle.size[1]))
            let pos = CGPoint(x: CGFloat(circle.pos[0]), y: CGFloat(circle.pos[1]))
            let rot = CGFloat(circle.rotation)
            let part = Circle(image: circle.sprite, size: size, pos: pos, rotation: rot)
            
            part.insertCollider()
            self.draggablesList.append(part)
            self.addChild(part.spriteNode!)
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let touchNodes = self.nodes(at: location)
        for node in touchNodes.reversed() {
            if node.name == "draggable" {
                self.touchedNode = node as? SKSpriteNode
                self.touchPoint = location
                self.touchDistToCenter = CGPoint(x: (self.touchedNode?.position.x)!-self.touchPoint!.x, y: (self.touchedNode?.position.y)!-self.touchPoint!.y)
                self.touching = true
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
        var i = 0
        for part in draggablesList{ //checa quantas pecas estão na silhueta
            if(part.checkInside(back: backImage!)){
                i += 1
            }
        }
        if(i == 2){ //se todas estiverem dentro ele executa o codigo
            //draggablesList ==
            endGame()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if touching { //executa o movimento da peca movida pelo usuario
            if touchPoint != self.touchedNode?.position
            {
                let dt:CGFloat = 0.01
                let distance = CGVector(dx: (touchPoint!.x+touchDistToCenter!.x)-(self.touchedNode?.position.x)!, dy: (touchPoint!.y+touchDistToCenter!.y)-(self.touchedNode?.position.y)!)
                let vel = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
                self.touchedNode!.physicsBody!.velocity = vel
            }
        }
        else { // para o movimento da peca quando o usuario tira o dedo
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
    
    func load<T: Decodable>(_ filename: String) -> T { //func para conseguir acessar um arquivo json
            let data: Data
            
            guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
                else {
                    fatalError("Couldn't find \(filename) in main bundle.")
            }
            
            do {
                data = try Data(contentsOf: file)
            } catch {
                fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
            }
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
        pauseMenu.zPosition = 1
        pauseMenu.alpha = 0
        addChild(pauseMenu)
        
        pauseMenu.run(  .fadeAlpha(to: 1, duration: 0.5))
        
        pause.run(  .fadeAlpha(to: 0, duration: 0.5)) {
            self.isPaused = true
        }
        
        
    }
    
    func endGame() {
        let endGame = LevelCompletePopUpView(size: CGSize(width: size.width - 64, height: size.height * 0.8))
        endGame.levelCompleteDelegate = self
        endGame.zPosition = 1
        endGame.alpha = 0
        addChild(endGame)
        
        endGame.run(  .fadeAlpha(to: 1, duration: 0.5))
        
        pause.run(  .fadeAlpha(to: 0, duration: 0.5)) {
            self.isPaused = true
        }
        
        let maxLvl = UserDefaults.standard.loadPlayerLevel()
        
        if maxLvl < level {
            UserDefaults.standard.savePlayerLevel(playerLevel: level)
        }
        
    }
}

extension GameScene: PauseMenuDelegate {
    func resumeLevel() {
        pause.run(  .fadeAlpha(to: 1, duration: 0.5)) {
            self.pause.isHidden = false
        }
        self.isPaused = false
    }
    
    func resetLevel() {
        changeLevel()
    }
    
    func exitLevel() {
        popView()
    }
}

extension GameScene: LevelCompleteMenuDelegate {
    func nextLevel() {
        viewControllerDelegate?.changeLevel()
    }
}

extension GameScene: PopViewControllerDelegate {
    func changeLevel() {
        self.viewControllerDelegate?.changeLevel()
    }
    
    func popView() {
        self.viewControllerDelegate?.popView()
    }
}

