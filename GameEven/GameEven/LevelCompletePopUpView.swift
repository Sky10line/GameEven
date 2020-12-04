//
//  LevelCompletePopUpView.swift
//  GameEven
//
//  Created by Rogerio Lucon on 29/10/20.
//

import Foundation
import SpriteKit

protocol LevelCompleteMenuDelegate {
    func nextLevel()
    func resetLevel()
    func exitLevel()
}

class LevelCompletePopUpView: SKSpriteNode {
    
    var levelCompleteDelegate: LevelCompleteMenuDelegate?
    
    private var balloon: SKSpriteNode!
    private var text: SKLabelNode!
    private var timeLabel: SKLabelNode!
    private var stars: SKSpriteNode!
    private var even: SKSpriteNode!
    private var nextBtt: SKSpriteNode!
    private var resetBtt: SKSpriteNode!
    private var mapBtt: SKSpriteNode!
    
    
    private var buttonSize: CGFloat!
    private var fontSize: CGFloat!
    private var level: Int!
    private var maxLvl = 7
    private var time: Int!
    let nStars: Int = 1
    
    private var audioPlayer = AudioManager.sharedInstance
    
    init(size: CGSize, level: Int, time: Int){
        self.level = level
        self.time = time
        
        super.init(texture: nil, color: .orange, size: size)
        texture = SKTexture(imageNamed: "Background-Fases")
        isUserInteractionEnabled = true
        
        buttonSize = 90
        fontSize = 30 * scaleValue()
        
        createBalloon()
        
        createTitle()
        
        createTime()
        
//        createStars()
        
        createResetBtt()
        
        createMapBtt()
        
        createNextBtt()
        
        createEven()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Elementos
    
    func createBalloon() {
        balloon = SKSpriteNode()
        balloon.texture =  SKTexture(imageNamed: "Backgroud-PopUp")
        balloon.size = CGSize(width: size.width * 0.85, height: size.height * 0.80)
        balloon.position = position
        balloon.zPosition = 1
        self.addChild(balloon)
    }
    
    func createTime() {
        let time = SKLabelNode(text: self.time.intToTime())
        let y = text.position.y - text.fontSize / 2 - time.fontSize / 2
        time.position = CGPoint(x: 0, y: y - 32 * scaleValue())
        time.fontSize = fontSize * 1.0
        time.fontColor = #colorLiteral(red: 0.04709532857, green: 0.04772982746, blue: 0.04688558728, alpha: 1)
        time.fontName = "Even"
        time.verticalAlignmentMode = .center
        time.zPosition = 1
        
        timeLabel = time
        
        balloon.addChild(timeLabel)
    }
    
    private func createTitle(){
        //EXCELENTE!
        let congrats = NSLocalizedString("YEAH!", comment: "Complete level title")
        
        text = SKLabelNode(text: congrats)
        text.position = CGPoint(x: 0, y: balloon.size.height / 2 - text.fontSize / 2 - 64 * scaleValue())
        text.fontSize = fontSize * 1.7
        text.fontColor = #colorLiteral(red: 0.06604217738, green: 0.6873383522, blue: 0.7892531753, alpha: 1)
        text.fontName = "Even"
        text.verticalAlignmentMode = .center
        text.zPosition = 1
        balloon.addChild(text)
    }
    
    func createStars(){
        
        let posY = timeLabel.position.y - timeLabel.fontSize / 2 - 16 * scaleValue()
        
        let stars2 = SKSpriteNode(imageNamed: "estrela")
        stars2.position.y = posY - stars2.size.height / 2
        stars2.size.width = 50 * scaleValue()
        stars2.zPosition = 1
        
        let stars1 = SKSpriteNode(imageNamed: "estrela")
        stars1.position.y = stars2.position.y
        stars1.position.x = stars2.position.x - stars2.size.width
        stars1.size.width = stars2.size.width
        stars1.zPosition = 1
        
        let stars3 = SKSpriteNode(imageNamed: "estrela")
        stars3.position.y = stars2.position.y
        stars3.position.x = stars2.position.x + stars2.size.width
        stars3.size.width = stars2.size.width
        stars3.zPosition = 1
        
        balloon.addChild(stars1)
        balloon.addChild(stars2)
        balloon.addChild(stars3)
    }
    
    private func createEven() {
        even = SKSpriteNode(
            color: .blue,
            size: CGSize(width: 300 * 0.68, height: 300)
        )
        even.resizeble()
        even.name = "even"
        even.texture = SKTexture(imageNamed: "Even-Next-2")
        even.position = CGPoint(x: 0, y: nextBtt.position.y + nextBtt.size.height / 2 + even.size.height / 2)
        even.position.y += 20 * scaleValue()
        even.zPosition = 1
        balloon.addChild(even)
    }
    
    private func createResetBtt(){
        resetBtt = SKSpriteNode(
            color: .red,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        resetBtt.resizeble()
        resetBtt.name = "reset"
        resetBtt.texture = SKTexture(imageNamed: "Button-Reset")
        let y: CGFloat = balloon.size.height / 2 - resetBtt.size.height / 2 - 64 * scaleValue()
        resetBtt.position = CGPoint(x: resetBtt.size.width / 2 + 16 * scaleValue(), y: -y)
        resetBtt.zPosition = 1
        balloon.addChild(resetBtt)
    }
    
    private func createMapBtt(){
        mapBtt = SKSpriteNode(
            color: .blue,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        mapBtt.resizeble()
        mapBtt.texture = SKTexture(imageNamed: "Button-Map")
        mapBtt.name = "exit"
        mapBtt.position = CGPoint(x: -mapBtt.size.width / 2 - 16 * scaleValue(), y: resetBtt.position.y)
        mapBtt.zPosition = 1
        balloon.addChild(mapBtt)
    }
    
    private func createNextBtt(){
        nextBtt = SKSpriteNode(
            color: .green,
            size: CGSize(width: buttonSize * 2 + 32, height: (buttonSize * 0.75) * 0.719)
        )
        nextBtt.resizeble()
        nextBtt.name = "next"
        if level >= maxLvl {
            nextBtt.texture = SKTexture(imageNamed: "Button-Next-Disable")
            nextBtt.color = .gray
            nextBtt.name = ""
        } else {
            nextBtt.texture = SKTexture(imageNamed: "Button-Next")
        }
        let y = resetBtt.position.y + resetBtt.size.height / 2 + nextBtt.size.height / 2
        nextBtt.position = CGPoint(x: 0, y: y + 32 * scaleValue())
        nextBtt.zPosition = 1
        balloon.addChild(nextBtt)
    }
    
    //MARK: Auxiliares
    
    //MARK: Interaçoes
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let touchedNodes = self.nodes(at: location)
            for node in touchedNodes.reversed() {
                switch node.name {
                case "exit":
                    exit()
                case "reset":
                    reset()
                case "next":
                    next()
                default:
                    break
                }
            }
        }
    }
    
    private func exit(){
        audioPlayer.playSound(SoundType: .button)
        levelCompleteDelegate?.exitLevel()
    }
    
    private func reset(){
        audioPlayer.playSound(SoundType: .button)
        levelCompleteDelegate?.resetLevel()
    }
    
    private func next(){
        audioPlayer.playSound(SoundType: .button)
        levelCompleteDelegate?.nextLevel()
    }
}
