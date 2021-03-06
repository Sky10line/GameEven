//
//  GameScene.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 26/10/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    public var level: Int = 0
    
    private var touchedNode: SKSpriteNode?
    private var touchedDrag: Draggable?
    private var touchNode: SKNode?
    private var draggablesList: [Draggable] = []
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
    
    private var levelTimerLabel: SKLabelNode!
    private var levelTimer: Int = 0 {
        didSet { levelTimerLabel?.text = levelTimer.intToTime()}
    }
    var levelTimerSequence: SKAction?
    
    private var audioPlayer = AudioManager.sharedInstance
    
    private var maxSilhouetteSize = CGFloat(330) // Determina até quanto a imagem pode ser escalonada em pixels, nos eixos X e Y.
    
    var viewControllerDelegate: PopViewControllerDelegate?
    
    override func didMove(to view: SKView) {
        self.view?.isMultipleTouchEnabled = false
        super.didMove(to: view)
        
        self.physicsWorld.contactDelegate = self
        
        //Background
        let bg = SKSpriteNode()
        bg.texture = SKTexture(imageNamed: "Background-Fases")
        bg.size = size
        bg.position = self.position
        bg.zPosition = 0
        addChild(bg)
        
        //Timer
        levelTimerLabel = SKLabelNode()
        levelTimerLabel.position.x = UIScreen.main.bounds.minX / 2 - 128
        levelTimerLabel.position.y = UIScreen.main.bounds.maxY / 2 - levelTimerLabel.fontSize - ( safeAreaInsets().top == .zero ? 32 : safeAreaInsets().top)
        levelTimerLabel.color = .white
        levelTimerLabel.horizontalAlignmentMode = .left
        levelTimerLabel.text = "00 : 00 : 00"
        levelTimerLabel.fontName = "Even"
        levelTimerLabel.zPosition = 4
        addChild(levelTimerLabel)
        
        let wait = SKAction.wait(forDuration: 1.0)
        let block = SKAction.run({
            [unowned self] in
            self.levelTimer += 1
        })
        levelTimerSequence = SKAction.sequence([wait,block])
        
        //Pause Btn
        pause = SKSpriteNode(
            color: .red,
            size: CGSize(width: 46, height: 46)
        )
        pause.name = "pause"
        pause.texture = SKTexture(imageNamed: "Button-Pause")
        pause.position.x = UIScreen.main.bounds.maxX / 2 - pause.size.width / 2 - 32
        pause.position.y = UIScreen.main.bounds.maxY / 2 - pause.size.height / 2 - ( safeAreaInsets().top == .zero ? 32 : safeAreaInsets().top)
        pause.zPosition = 4
        self.addChild(pause)
        
        self.insertEdgeColliders() // create edge colliders to parts don't leave the screen
        self.touchNode = SKNode() // create a node called touchNode to represent touch
        self.touchNode?.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(30)) // create collider to this node
        
        if let pb = touchNode?.physicsBody {
            pb.categoryBitMask = 4
            pb.collisionBitMask = 0
            pb.contactTestBitMask = 1
            pb.affectedByGravity = false
            pb.isDynamic = true
            pb.allowsRotation = false
            pb.usesPreciseCollisionDetection = true
        }
        addChild(self.touchNode!)
        
        //Create level
        let lvl: lvlReader = load("lvl\(level).json")
        
        // Show Instructions
        let i = InstructionPopUpView(size: size, lvl.instruction)
        i.zPosition = 4
        i.delegate = self
        addChild(i)
        
        //create the silhouette
        let silhouette = lvl.silhouette
        let back = SKSpriteNode(imageNamed: silhouette.sprite)
        
        func deviceScale (v: CGFloat) -> CGFloat {
            return CGFloat(UIScreen.main.bounds.maxY * v / 896)
        }
        
        let levelScaleSize = (deviceScale(v: (maxSilhouetteSize + CGFloat(silhouette.size[0]))) / max(back.size.width,back.size.height))
        
        back.size = CGSize(width: back.size.width * levelScaleSize , height: back.size.height * levelScaleSize)
        
        back.position = CGPoint(x: CGFloat(silhouette.pos[0]), y: deviceScale(v: CGFloat(silhouette.pos[1])))
        back.zRotation = CGFloat(silhouette.rotation)
        self.backImage = back
        back.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: silhouette.sprite), size: back.size)
        
        if let pb = back.physicsBody{
            pb.categoryBitMask = 16
            pb.collisionBitMask = 0
            pb.contactTestBitMask = 2
            pb.affectedByGravity = false
            pb.isDynamic = true
            pb.allowsRotation = false
            pb.usesPreciseCollisionDetection = true
        }
        back.zPosition = 2
        self.addChild(back)
        
        //create squares
        for square in lvl.squares{
            //let size = CGSize(width: CGFloat(square.size[0]), height: CGFloat(square.size[1]))
            let pos = CGPoint(x: CGFloat(square.pos[0]), y: CGFloat(square.pos[1]))
            let rot = CGFloat(square.rotation)
            let part = Square(drag: createDragSprite(image: square.sprite, pos: pos, rot: rot, scale: levelScaleSize))
            
            part.insertCollider()
            self.draggablesList.append(part)
        }
        
        //create triangles
        for triangle in lvl.triangles {
            //let size = CGSize(width: CGFloat(triangle.size[0]), height: CGFloat(triangle.size[1]))
            let pos = CGPoint(x: CGFloat(triangle.pos[0]), y: CGFloat(triangle.pos[1]))
            let rot = CGFloat(triangle.rotation)
            let part = Triangle(drag: createDragSprite(image: triangle.sprite, pos: pos, rot: rot, scale: levelScaleSize))
            
            part.setThirdPoint(Point: CGFloat(triangle.thirdPoint))
            
            part.insertCollider()
            self.draggablesList.append(part)
        }
        
        //        create circles
        for circle in lvl.circles {
            //let size = CGSize(width: CGFloat(circle.size[0]), height: CGFloat(circle.size[1]))
            let pos = CGPoint(x: CGFloat(circle.pos[0]), y: CGFloat(circle.pos[1]))
            let rot = CGFloat(circle.rotation)
            let part = Circle(drag: createDragSprite(image: circle.sprite, pos: pos, rot: rot, scale: levelScaleSize))
            
            part.insertCollider()
            self.draggablesList.append(part)
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
                if touchedNode == nil && node.physicsBody != nil && contacteds!.contains(node.physicsBody!) {
                    self.touchedNode = node as? SKSpriteNode
                    for drag in draggablesList{
                        if(drag.spriteNode == self.touchedNode){
                            touchedDrag = drag
                            break
                        }
                    }
                    if let pb = self.touchedNode?.physicsBody{ //change bitmasks to drag without any trouble
                        pb.categoryBitMask = 0
                        pb.collisionBitMask = 0
                    }
                    self.touchedNode?.zPosition = 3
                    self.touchPoint = location
                    self.touchDistToCenter = CGPoint(x: (self.touchedNode?.position.x)!-self.touchPoint!.x, y: (self.touchedNode?.position.y)!-self.touchPoint!.y)
                    self.touching = true //set var to let the part move in update func
                }
            }
        }
        if self.touchedNode != nil { //check if touchedNode is not nil
            touchPoint = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchedNode?.physicsBody?.categoryBitMask = 1
        touchedNode?.physicsBody?.collisionBitMask = 9
        //        if touching {
        //            audioPlayer.playSound(SoundType: .placePiece)
        //        }
        touching = false
        
        
        if checkVitory() {
            pause.run(SKAction.fadeAlpha(to: 0, duration: 0.2)){
                self.pause.isHidden = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                if checkVitory() {
                    audioPlayer.playSound(SoundType: .victory)
                    endGame()
                } else{
                    pause.run(SKAction.fadeAlpha(to: 1, duration: 0.2)) {
                        self.pause.isHidden = false
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchedNode?.physicsBody?.categoryBitMask = 1
        touchedNode?.physicsBody?.collisionBitMask = 9
        //        if touching {
        //            audioPlayer.playSound(SoundType: .placePiece)
        //        }
        touching = false
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if touching { //execute movement
            
            distance = CGVector(dx: (touchPoint!.x+touchDistToCenter!.x)-(self.touchedNode?.position.x)!, dy: (touchPoint!.y+touchDistToCenter!.y)-(self.touchedNode?.position.y)!) //calculate the dist from part to touch location
            
            vel = CGVector(dx: (distance?.dx ?? 0)/dt, dy: (distance?.dy ?? 0)/dt) //create a velocity to move part to touch location
            
            moveNode(node: self.touchedNode!)
            for child in self.touchedNode!.children{
                distance = CGVector(dx: (touchPoint!.x+touchDistToCenter!.x)-(child.position.x), dy: (touchPoint!.y+touchDistToCenter!.y)-(child.position.y))
                
                moveNode(node: child)
            }
        }
        else { //stop movement when user is not touching anymore
            for drag in draggablesList{
                drag.correctPointPos()
            }
            if(touchedNode != nil){
                audioPlayer.playSound(SoundType: .placePiece)
                vel = nil
                moveNode(node: self.touchedNode!)
                for child in self.touchedNode!.children{
                    moveNode(node: child)
                }
                self.touchedNode?.zPosition = 0
                self.touchedNode = nil
                self.touchedDrag = nil
            }
        }
    }
    
    @objc func checkVitory() -> Bool {
        i = 0
        for part in draggablesList { // check how many parts is in the silhouette
            if part.checkInside(back: backImage!, scene: scene! as SKNode) {
                i += 1
            }
        }
        if i == draggablesList.count { // check if all the parts is inside
            return true
        }
        return false
    }
    
    func moveNode(node: SKNode) {
        node.physicsBody!.velocity = vel ?? CGVector.zero //move part with velocity
    }
    
    func didEnd(_ contact: SKPhysicsContact) { // stop movement of any part that end contact with other
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        bodyA.velocity = CGVector(dx: 0, dy: 0)
        bodyB.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func createDragSprite(image: String, pos: CGPoint, rot: CGFloat, scale: CGFloat) -> Draggable {
        let part = Draggable(image: image, pos: pos, rotation: rot, imageScale: scale)
        
        part.spriteNode!.zPosition = 3
        self.addChild(part.spriteNode!)
        
        return part
    }
    
    func insertEdgeColliders(){
        createEdgeCollider(width: frame.width*3, height: frame.height, posX: 0, posY: frame.height) //create up limit collider
        createEdgeCollider(width: frame.width*3, height: frame.height, posX: 0, posY: -frame.height) //create down limit collider
        createEdgeCollider(width: frame.width, height: frame.height*3, posX: -frame.width, posY: 0) //create left limit collider
        createEdgeCollider(width: frame.width, height: frame.height*3, posX: frame.width, posY: 0) //create right limite collider
    }
    
    func createEdgeCollider(width: CGFloat, height: CGFloat, posX: CGFloat, posY: CGFloat) { //create all edge colliders
        let edge = SKNode()
        edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        edge.position = CGPoint(x: posX, y: posY)
        
        if let pb = edge.physicsBody{
            pb.categoryBitMask = 8
            pb.affectedByGravity = false
            //            pb.pinned = true
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
        
        audioPlayer.playSound(SoundType: .button)
        
        let pauseMenu = PausePopUpView(size: CGSize(width: size.width, height: size.height))
        pauseMenu.pauseDelegate = self
        pauseMenu.zPosition = 4
        pauseMenu.alpha = 0
        addChild(pauseMenu)
        
        pauseMenu.run(  .fadeAlpha(to: 1, duration: 0.5))
        
        pause.run(  .fadeAlpha(to: 0, duration: 0.5)) {
            self.isPaused = true
            self.pauseTimer()
        }
    }
    
    func endGame() {
        
        let endGame = LevelCompletePopUpView(size: CGSize(width: size.width, height: size.height), level: level, time: levelTimer)
        endGame.levelCompleteDelegate = self
        endGame.zPosition = 4
        endGame.alpha = 0
        addChild(endGame)
        
        endGame.run(  .fadeAlpha(to: 1, duration: 0.5))
        
        pause.run(  .fadeAlpha(to: 0, duration: 0.5)) {
            self.isPaused = true
        }
        
        let maxLvl = UserDefaults.standard.loadPlayerLevel()
        
        if maxLvl < level + 1 {
            UserDefaults.standard.savePlayerLevel(playerLevel: level + 1)
        }
    }
    
    private func pauseTimer() {
        if action(forKey: "countdown") != nil {removeAction(forKey: "countdown")}
    }
    
    private func activeTimer() {
        run(SKAction.repeatForever(levelTimerSequence!), withKey: "countdown")
    }
    
}

//MARK: - Delegates, extensions

extension GameScene: PauseMenuDelegate {
    func resumeLevel() {
        pause.run(  .fadeAlpha(to: 1, duration: 0.5)) {
            self.pause.isHidden = false
        }
        self.isPaused = false
        activeTimer()
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

