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
    
    init(size: CGSize){
        
        super.init(texture: nil, color: .orange, size: size)
        
        isUserInteractionEnabled = true
        
        buttonSize = scale(90)
        fontSize = scale(28)
        
        //Reset Btt
        let resetLevel = SKSpriteNode(
            color: .red,
            size: CGSize(width: buttonSize, height: buttonSize)
        )
        resetLevel.name = "reset"
        resetLevel.texture = SKTexture(imageNamed: "ResetButton")
        var y: CGFloat = size.height / 2 - resetLevel.size.height / 2 - scale(64)
        resetLevel.position = CGPoint(x: resetLevel.size.width / 2 + scale(16), y: -y)
        self.addChild(resetLevel)
        
        //Exit to Map Btt
        let map = SKSpriteNode(
            color: .blue,
            size: CGSize(width: buttonSize, height: buttonSize)
        )
        map.texture = SKTexture(imageNamed: "MapButton")
        map.name = "exit"
        map.position = CGPoint(x: -map.size.width / 2 - scale(16), y: -y)
        self.addChild(map)
        
        //EXCELENTE!
        let text = SKLabelNode(text: "EXCELENTE!")
        text.position = CGPoint(x: 0, y: size.height / 2 - text.fontSize / 2 - scale(64))
        text.fontSize = fontSize * 1.7
        text.fontColor = .black
        text.verticalAlignmentMode = .center
        self.addChild(text)
    
        //Next Btt
        let next = SKSpriteNode(
            color: .green,
            size: CGSize(width: buttonSize * 2 + scale(32), height: buttonSize * 0.75)
        )
        next.name = "next"
        next.texture = SKTexture(imageNamed: "NextButton")
        y = resetLevel.position.y + resetLevel.size.height / 2 + next.size.height / 2
        next.position = CGPoint(x: 0, y: y + scale(32))
        self.addChild(next)
        
        //Even
        let even = SKSpriteNode(
            color: .blue,
            size: CGSize(width: scale(200), height: scale(200))
        )
        even.name = "even"
        even.position = CGPoint(x: 0, y: next.position.y + next.size.height / 2 + even.size.height / 2 + scale(80))
        self.addChild(even)
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
                print("NODE TOUCH: \(String(describing: node.name))")
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
