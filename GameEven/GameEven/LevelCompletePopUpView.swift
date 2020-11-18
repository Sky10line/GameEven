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
    
    private var buttonSize: CGFloat!
    private var fontSize: CGFloat!
    private var level: Int!
    private var maxLvl = 7
    init(size: CGSize, level: Int){
        self.level = level
        
        super.init(texture: nil, color: .orange, size: size)
        texture = SKTexture(imageNamed: "Background-Fases")
        isUserInteractionEnabled = true
        
        buttonSize = scale(90)
        fontSize = scale(30)
        
        let balloon = SKSpriteNode()
        balloon.texture =  SKTexture(imageNamed: "Backgroud-PopUp")
        balloon.size = CGSize(width: size.width * 0.85, height: size.height * 0.80)
        balloon.position = position
        balloon.zPosition = 1
        self.addChild(balloon)
        
        //Reset Btt
        let resetLevel = SKSpriteNode(
            color: .red,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        resetLevel.name = "reset"
        resetLevel.texture = SKTexture(imageNamed: "Button-Reset")
        var y: CGFloat = balloon.size.height / 2 - resetLevel.size.height / 2 - scale(64)
        resetLevel.position = CGPoint(x: resetLevel.size.width / 2 + scale(16), y: -y)
        resetLevel.zPosition = 1
        balloon.addChild(resetLevel)
        
        //Exit to Map Btt
        let map = SKSpriteNode(
            color: .blue,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        map.texture = SKTexture(imageNamed: "Button-Map")
        map.name = "exit"
        map.position = CGPoint(x: -map.size.width / 2 - scale(16), y: -y)
        map.zPosition = 1
        balloon.addChild(map)
        
        //EXCELENTE!
        let congrats = NSLocalizedString("YEAH!", comment: "Complete level title")
        
        let text = SKLabelNode(text: congrats)
        text.position = CGPoint(x: 0, y: balloon.size.height / 2 - text.fontSize / 2 - scale(64))
        text.fontSize = fontSize * 1.7
        text.fontColor = #colorLiteral(red: 0.06604217738, green: 0.6873383522, blue: 0.7892531753, alpha: 1)
        text.fontName = "Even"
        text.verticalAlignmentMode = .center
        text.zPosition = 1
        balloon.addChild(text)
    
        //Next Btt
        let next = SKSpriteNode(
            color: .green,
            size: CGSize(width: buttonSize * 2 + scale(32), height: (buttonSize * 0.75) * 0.719)
        )
        next.name = "next"
        if level >= maxLvl {
            next.texture = SKTexture(imageNamed: "Button-Next-Disable")
            next.color = .gray
            next.name = ""
        } else {
            next.texture = SKTexture(imageNamed: "Button-Next")
        }
        y = resetLevel.position.y + resetLevel.size.height / 2 + next.size.height / 2
        next.position = CGPoint(x: 0, y: y + scale(32))
        next.zPosition = 1
        balloon.addChild(next)
        
        //Even
        let even = SKSpriteNode(
            color: .blue,
            size: CGSize(width: scale(300) * 0.68, height: scale(300))
        )
        even.name = "even"
        even.texture = SKTexture(imageNamed: "Even-Next")
        even.position = CGPoint(x: 0, y: next.position.y + next.size.height / 2 + even.size.height / 2 + scale(60))
        even.zPosition = 1
        balloon.addChild(even)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    //Interacoes
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
