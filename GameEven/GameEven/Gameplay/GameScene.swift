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
    private var touchNode: SKNode?
    private var draggablesList: [DraggableProtocol] = []
    private var backImage: SKSpriteNode?
    private var win = false
    public var level: Int = 2
    
    private var touching = false
    private var touchPoint: CGPoint?
    private var touchDistToCenter: CGPoint?
    private var allowMove = true
    
    private var pause: SKSpriteNode!
    
    var viewControllerDelegate: PopViewControllerDelegate?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
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
        
//        let back = SKSpriteNode(color: .purple, size: CGSize(width: 160, height: 320))
//
//        back.position = CGPoint(x: 0, y: 0)
//        back.name = "silhouette"
//
//        back.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 160, height: 320))
//
//        if let bpb = back.physicsBody{
//            bpb.categoryBitMask = UInt32(2)
//            bpb.collisionBitMask = UInt32(2)
//            bpb.contactTestBitMask = 1
//            bpb.affectedByGravity = false
//            bpb.isDynamic = false
//            bpb.allowsRotation = false
//            bpb.usesPreciseCollisionDetection = true
//        }
//        self.backImage = back
//        self.addChild(back)
        
        self.insertEdgeColliders()
        
        let lvl: lvlReader = load("lvl\(level).json")
        
        let silhouette = lvl.silhouette
        let back = SKSpriteNode(imageNamed: silhouette.sprite)
        back.size = CGSize(width: CGFloat(silhouette.size[0]), height: CGFloat(silhouette.size[1]))
        back.position = CGPoint(x: CGFloat(silhouette.pos[0]), y: CGFloat(silhouette.pos[1]))
        back.zRotation = CGFloat(silhouette.rotation)
        self.backImage = back
        self.addChild(back)
        
        for square in lvl.squares{
            let size = CGSize(width: CGFloat(square.size[0]), height: CGFloat(square.size[1]))
            let pos = CGPoint(x: CGFloat(square.pos[0]), y: CGFloat(square.pos[1]))
            let rot = CGFloat(square.rotation)
            let part = Square(image: square.sprite, size: size, pos: pos, rotation: rot)
            
            part.insertCollider()
            self.draggablesList.append(part)
            self.addChild(part.spriteNode!)
        }
        
        for triangle in lvl.triangles {
            let size = CGSize(width: CGFloat(triangle.size[0]), height: CGFloat(triangle.size[1]))
            let pos = CGPoint(x: CGFloat(triangle.pos[0]), y: CGFloat(triangle.pos[1]))
            let rot = CGFloat(triangle.rotation)
            let part = Triangle(image: triangle.sprite, size: size, pos: pos, rotation: rot)
            part.setThirdPoint(Point: CGPoint(x: CGFloat(triangle.thirdPoint[0]), y: CGFloat(triangle.thirdPoint[1])))
            
            part.insertCollider()
            self.draggablesList.append(part)
            self.addChild(part.spriteNode!)
        }
        
        for circle in lvl.circles {
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
            if self.touchedNode == nil {
                if node.name == "draggable" {
                    self.touchedNode = node as? SKSpriteNode
                    if let pb = self.touchedNode!.physicsBody{
                        pb.categoryBitMask = UInt32(10780)
                        pb.collisionBitMask = UInt32(10780)
                        pb.contactTestBitMask = 1
                    }
                    self.touchPoint = location
                    self.touchDistToCenter = CGPoint(x: (self.touchedNode?.position.x)!-self.touchPoint!.x, y: (self.touchedNode?.position.y)!-self.touchPoint!.y)
                    self.touching = true
                    print("achou")
                    
                }
                if node.name == "pause" {
                    pauseGame()
                }
            }
        }
    }
    
    let maxDistActiveMove: CGFloat = 100
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let node = touchedNode else {
            return
        }
        let touch = touches.first!
        let location = touch.location(in: self)
        if euclideanDist(distance: node.position, distance: location) < maxDistActiveMove {
            touchPoint = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchedNode?.physicsBody?.collisionBitMask = 1
        touchedNode?.physicsBody?.categoryBitMask = 1
        touching = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
        touchedNode?.physicsBody?.collisionBitMask = 1
        touchedNode?.physicsBody?.categoryBitMask = 1
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if touching { //executa o movimento da peca movida pelo usuario
            
//            if touchPoint != self.touchedNode?.position
//            {
            
            let dt = CGFloat(0.01)
            
            let distance = CGVector(dx: (touchPoint!.x+touchDistToCenter!.x)-(self.touchedNode?.position.x)!, dy: (touchPoint!.y+touchDistToCenter!.y)-(self.touchedNode?.position.y)!)
            
//            let dtX = insideBorder(value: (touchPoint!.x+touchDistToCenter!.x), min: -frame.width/2 + self.touchedNode!.size.width/2, max: frame.width/2 - self.touchedNode!.size.width/2)
//
//            let dtY = insideBorder(value: (touchPoint!.y+touchDistToCenter!.y), min: -frame.height/2 + self.touchedNode!.size.height/2, max: frame.height/2 - self.touchedNode!.size.height/2)
            
//            print("\(dtX), \(dtY)")
                
            let vel = CGVector(dx: (distance.dx/*dtX)*/)/dt, dy: (distance.dy/*dtY)*/)/dt)
            self.touchedNode!.physicsBody!.velocity = vel
            
            print("\(vel)")
//            }
        }
        else { // para o movimento da peca quando o usuario tira o dedo
            self.touchedNode?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.touchedNode = nil
            
            var i = 0
            for part in draggablesList{ //checa quantas pecas estão na silhueta
                if(part.checkInside(back: backImage!)){
                    i += 1
                }
            }
            if(i == draggablesList.count){ //se todas estiverem dentro ele executa o codigo
                //draggablesList ==
                endGame()
            }
        }
    }
    
    func insideBorder(value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        if value > max {
            return 0
        }
        if value < min {
            return 0
        }
        return 1
    }
    
    func resetScene(_ lvl: Int){ // func reseta a cena e carrega o lvl desejado
        if let scene = SKScene(fileNamed: "GameScene") {
            (scene as? GameScene)?.level = lvl
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.size = UIScreen.main.bounds.size
//            let transition = SKTransition.fade(withDuration: 1.0)
            // Present the scene
            view!.presentScene(scene)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
    
        bodyA.velocity = CGVector(dx: 0, dy: 0)
        bodyB.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func insertEdgeColliders(){
        createEdgeCollider(width: frame.width, height: frame.height, posX: 0, posY: frame.height) //create up limit collider
        createEdgeCollider(width: frame.width, height: frame.height, posX: 0, posY: -frame.height) //create down limit collider
        createEdgeCollider(width: frame.width, height: frame.height, posX: -frame.width, posY: 0) //create left limit collider
        createEdgeCollider(width: frame.width, height: frame.height, posX: frame.width, posY: 0) //create right limite collider
    }
    
    func createEdgeCollider(width: CGFloat, height: CGFloat, posX: CGFloat, posY: CGFloat){
        let edge = SKShapeNode(rect: CGRect(x: -width/2, y: -height/2, width: width, height: height))
        edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        edge.position = CGPoint(x: posX, y: posY)
        
        if let pb = edge.physicsBody{
            pb.categoryBitMask = 1
            pb.collisionBitMask = 1
            pb.contactTestBitMask = 1
            pb.affectedByGravity = false
            pb.isDynamic = false
            pb.allowsRotation = false
            pb.usesPreciseCollisionDetection = true
        }
        self.addChild(edge)
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
        let endGame = LevelCompletePopUpView(size: CGSize(width: size.width - 64, height: size.height * 0.8), level: level)
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
    
    private func euclideanDist(distance a: CGPoint, distance b: CGPoint) -> CGFloat {
        let x = abs(a.x - b.x)
        let y = abs(a.y - b.y)
        return sqrt(x * x + y * y)
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
        changeLevel(changeTo: level)
    }
    
    func exitLevel() {
        popView()
    }
}

extension GameScene: LevelCompleteMenuDelegate {
    func nextLevel() {
        self.viewControllerDelegate?.changeLevel(changeTo: level + 1)
    }
}

extension GameScene: PopViewControllerDelegate {
    func changeLevel(changeTo level: Int) {
        self.viewControllerDelegate?.changeLevel(changeTo: level)
    }
    
    func popView() {
        self.viewControllerDelegate?.popView()
    }
}

