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
    private var resetLevel: SKSpriteNode!
    private var map: SKSpriteNode!
    
    
    private var buttonSize: CGFloat!
    private var fontSize: CGFloat!
    private var level: Int!
    private var maxLvl = 7
    private var time: Int!
    let nStars: Int = 1
    
    init(size: CGSize, level: Int, time: Int){
        self.level = level
        self.time = time
        
        super.init(texture: nil, color: .orange, size: size)
        texture = SKTexture(imageNamed: "Background-Fases")
        isUserInteractionEnabled = true
        
        buttonSize = scale(90)
        fontSize = scale(30)
        
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
    
    func createTime(){
        let time = SKLabelNode(text: intToTime(time: self.time))
        let y = text.position.y - text.fontSize / 2 - time.fontSize / 2
        time.position = CGPoint(x: 0, y: y - scale(32))
        time.fontSize = fontSize * 1.0
        time.fontColor = .black
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
        text.position = CGPoint(x: 0, y: balloon.size.height / 2 - text.fontSize / 2 - scale(64))
        text.fontSize = fontSize * 1.7
        text.fontColor = #colorLiteral(red: 0.06604217738, green: 0.6873383522, blue: 0.7892531753, alpha: 1)
        text.fontName = "Even"
        text.verticalAlignmentMode = .center
        text.zPosition = 1
        balloon.addChild(text)
    }
    
    func createStars(){
        
        let posY = timeLabel.position.y - timeLabel.fontSize / 2 - scale(16)
        
        let stars2 = SKSpriteNode(imageNamed: "estrela")
        stars2.position.y = posY - stars2.size.height / 2
        stars2.size.width = scale(50)
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
        let even = SKSpriteNode(
            color: .blue,
            size: CGSize(width: scale(200) * 0.68, height: scale(200))
        )
        even.name = "even"
        even.texture = SKTexture(imageNamed: "Even-Next")
        even.position = CGPoint(x: 0, y: nextBtt.position.y + nextBtt.size.height / 2 + even.size.height / 2 + scale(60))
        even.zPosition = 1
        balloon.addChild(even)
    }
    
    private func createResetBtt(){
        resetLevel = SKSpriteNode(
            color: .red,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        resetLevel.name = "reset"
        resetLevel.texture = SKTexture(imageNamed: "Button-Reset")
        let y: CGFloat = balloon.size.height / 2 - resetLevel.size.height / 2 - scale(64)
        resetLevel.position = CGPoint(x: resetLevel.size.width / 2 + scale(16), y: -y)
        resetLevel.zPosition = 1
        balloon.addChild(resetLevel)
    }
    
    private func createMapBtt(){
        map = SKSpriteNode(
            color: .blue,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        map.texture = SKTexture(imageNamed: "Button-Map")
        map.name = "exit"
        map.position = CGPoint(x: -map.size.width / 2 - scale(16), y: resetLevel.position.y)
        map.zPosition = 1
        balloon.addChild(map)
    }
    
    private func createNextBtt(){
        nextBtt = SKSpriteNode(
            color: .green,
            size: CGSize(width: buttonSize * 2 + scale(32), height: (buttonSize * 0.75) * 0.719)
        )
        nextBtt.name = "next"
        if level >= maxLvl {
            nextBtt.texture = SKTexture(imageNamed: "Button-Next-Disable")
            nextBtt.color = .gray
            nextBtt.name = ""
        } else {
            nextBtt.texture = SKTexture(imageNamed: "Button-Next")
        }
        let y = resetLevel.position.y + resetLevel.size.height / 2 + nextBtt.size.height / 2
        nextBtt.position = CGPoint(x: 0, y: y + scale(32))
        nextBtt.zPosition = 1
        balloon.addChild(nextBtt)
    }
    
    //MARK: Auxiliares
    //Ajusta para fazer percetual ao tamanho original - Base iphone 11
    private func scale(_ valueToScale: CGFloat) -> CGFloat {
        let base: CGFloat = 414
        let screen = UIScreen.main.bounds
        let newDimension: CGFloat = min(screen.height, screen.width)
        
        var scale: CGFloat = ((100 * newDimension) / base) / 100
        
        if scale > 2 {
            scale = 2
        }
        return valueToScale * scale
    }
    
    private func intToTime(time: Int) -> String {
        let (_,m,s) = secondsToHoursMinutesSeconds(seconds: time)
        return "\(m) min \(s) sec"
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
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
        levelCompleteDelegate?.exitLevel()
    }
    
    private func reset(){
        levelCompleteDelegate?.resetLevel()
    }
    
    private func next(){
        levelCompleteDelegate?.nextLevel()
    }
    
}

extension SKSpriteNode {
    func drawBorder(color: UIColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rect: frame)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        addChild(shapeNode)
    }
}
