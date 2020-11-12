//
//  GameScene.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 26/10/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    public var level: Int = 2
    
    private var touchedNode: SKSpriteNode?
    private var touchNode: SKNode?
    private var draggablesList: [DraggableProtocol] = []
    private var backImage: SKSpriteNode?
    
    private var touch: UITouch?
    private var location: CGPoint?
    private var touchedNodes: [SKNode]?
    private var contacteds: [SKPhysicsBody]?
    
    private var touching = false
    private var touchPoint: CGPoint?
    private var touchDistToCenter: CGPoint?
    private var allowMove = true
    
    private var i: Int!
    
    private var dt = CGFloat(0.01)
    private var distance: CGVector?
    private var vel: CGVector?
    
    private var pause: SKSpriteNode!
    
    var viewControllerDelegate: PopViewControllerDelegate?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.physicsWorld.contactDelegate = self
        
        //Pause Btn
        pause = SKSpriteNode(
            color: .red,
            size: CGSize(width: 46, height: 46)
        )
        
        pause.name = "pause"
        pause.texture = SKTexture(imageNamed: "Button-Pause")
        pause.position.x = UIScreen.main.bounds.maxX / 2 - pause.size.width / 2 - 32
        pause.position.y = UIScreen.main.bounds.maxY / 2 - pause.size.height / 2 - ( safeAreaInsets().top == .zero ? 32 : safeAreaInsets().top)
        self.addChild(pause)
        
        self.insertEdgeColliders() // create edge colliders to parts don't leave the screen
        self.touchNode = SKNode() // create a node called touchNode to represent touch
        self.touchNode?.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(30)) // create collider to this node
        
        if let pb = touchNode?.physicsBody {
            pb.categoryBitMask = UInt32(6)
            pb.collisionBitMask = UInt32(6)
            pb.contactTestBitMask = 1
            pb.affectedByGravity = false
            pb.isDynamic = true
            pb.allowsRotation = false
            pb.usesPreciseCollisionDetection = true
        }
        addChild(self.touchNode!)
        
        //make Sprites
        let lvl: lvlReader = load("lvl\(level).json")
        
        //create the silhouette
        let silhouette = lvl.silhouette
        let back = SKSpriteNode(imageNamed: silhouette.sprite)
        back.size = CGSize(width: CGFloat(silhouette.size[0]), height: CGFloat(silhouette.size[1]))
        back.position = CGPoint(x: CGFloat(silhouette.pos[0]), y: CGFloat(silhouette.pos[1]))
        back.zRotation = CGFloat(silhouette.rotation)
        self.backImage = back
        self.addChild(back)
        
        //create squares
        for square in lvl.squares{
            let size = CGSize(width: CGFloat(square.size[0]), height: CGFloat(square.size[1]))
            let pos = CGPoint(x: CGFloat(square.pos[0]), y: CGFloat(square.pos[1]))
            let rot = CGFloat(square.rotation)
            let part = Square(image: square.sprite, size: size, pos: pos, rotation: rot)
            
            part.insertCollider()
            self.draggablesList.append(part)
            self.addChild(part.spriteNode!)
        }
        
        //create triangles
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
        
        //create circles
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
        touch = touches.first!
        location = touch?.location(in: self)
        self.touchNode?.position = location ?? CGPoint(x: 0, y: 0) //set touchNode to touch location
        touchedNodes = self.nodes(at: self.touchNode?.position ?? CGPoint(x: 0, y: 0)) //get nodes that are in touchNode position
        
        for node in touchedNodes!.reversed() { //check if the node that is being touched is pause
            if node.name == "pause" {
                pauseGame()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first!
        location = touch?.location(in: self)
        
        contacteds = self.touchNode?.physicsBody?.allContactedBodies() //get physics bodies in contact with touchNode

        //check contacts and select part to drag
        if contacteds!.count > 0 {
            let touchedNodes = self.nodes(at: self.touchNode!.position)
            for node in touchedNodes.reversed() {
                if touchedNode == nil {
                    if node.physicsBody != nil {
                        if contacteds!.contains(node.physicsBody!) {
                            self.touchedNode = node as? SKSpriteNode
                            if let pb = self.touchedNode!.physicsBody{ //change bitmasks to drag without any trouble
                                pb.categoryBitMask = UInt32(8)
                                pb.collisionBitMask = UInt32(8)
                                pb.contactTestBitMask = 1
                            }
                            self.touchPoint = location
                            self.touchDistToCenter = CGPoint(x: (self.touchedNode?.position.x)!-self.touchPoint!.x, y: (self.touchedNode?.position.y)!-self.touchPoint!.y)
                            
                            self.touching = true //set var to let the part move in update func
                            
                        }
                    }
                }
            }
        }
        
        guard let node = touchedNode else {
            return
        }
        if self.touchedNode != nil { //check if touchedNode is not nil
            touchPoint = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchedNode?.physicsBody?.collisionBitMask = 1
        touchedNode?.physicsBody?.categoryBitMask = 1
        touching = false
        
        i = 0
        for part in draggablesList { // check how many parts is in the silhouette
            if part.checkInside(back: backImage!) {
                i += 1
            }
        }
        if i == draggablesList.count { // check if all the parts is inside
            endGame()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
        touchedNode?.physicsBody?.collisionBitMask = 1
        touchedNode?.physicsBody?.categoryBitMask = 1
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if touching { //executa o movimento da peca movida pelo usuario
            
            distance = CGVector(dx: (touchPoint!.x+touchDistToCenter!.x)-(self.touchedNode?.position.x)!, dy: (touchPoint!.y+touchDistToCenter!.y)-(self.touchedNode?.position.y)!) //calculate the dist from part to touch location
            
            vel = CGVector(dx: (distance?.dx ?? 0)/dt, dy: (distance?.dy ?? 0)/dt) //create a velocity to move part to touch location
            self.touchedNode!.physicsBody!.velocity = vel ?? CGVector(dx: 0, dy: 0) //move part with velocity
        }
        else { //stop movement when user is not touching anymore
            self.touchedNode?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.touchedNode = nil
        }
    }
    private func euclideanDist(distance a: CGPoint, distance b: CGPoint) -> CGFloat { //func to calculate euclidean distance of two points
        let x = abs(a.x - b.x)
        let y = abs(a.y - b.y)
        return sqrt(x * x + y * y)
    }
    
    func resetScene(_ lvl: Int){ // func to reset scene to required level
        if let scene = SKScene(fileNamed: "GameScene") {
            (scene as? GameScene)?.level = lvl
            scene.scaleMode = .aspectFill
            scene.size = UIScreen.main.bounds.size
            //            let transition = SKTransition.fade(withDuration: 1.0)
            view!.presentScene(scene)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) { // stop movement of any part that end contact with other
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
    
    func createEdgeCollider(width: CGFloat, height: CGFloat, posX: CGFloat, posY: CGFloat) { //create all edge colliders
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
    
    func load<T: Decodable>(_ filename: String) -> T { //func to read json file
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

