//
//  PausePopUpView.swift
//  GameEven
//
//  Created by Rogerio Lucon on 27/10/20.
//

import Foundation
import SpriteKit

protocol PauseMenuDelegate {
    func resumeLevel()
    func resetLevel()
    func exitLevel()
}

class PausePopUpView: SKSpriteNode {
    
    var pauseDelegate: PauseMenuDelegate?
    
    private var buttonSize: CGFloat!
    private var fontSize: CGFloat!
    
    init(size: CGSize){
        
        super.init(texture: nil, color: .orange, size: size)
        texture = SKTexture(imageNamed: "Backgroud-PopUp")
        
        isUserInteractionEnabled = true
        
        buttonSize = scale(90)
        fontSize = scale(28)
        
        //Reset Btt
        let resetLevel = SKSpriteNode(
            color: .red,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        resetLevel.name = "reset"
        var y: CGFloat = size.height / 2 - resetLevel.size.height / 2 - scale(64)
        resetLevel.texture = SKTexture(imageNamed: "Button-Reset")
        resetLevel.position = CGPoint(x: resetLevel.size.width / 2 + scale(16), y: -y)
        resetLevel.zPosition = 1
        self.addChild(resetLevel)
        
        //Exit to Map Btt
        let map = SKSpriteNode(
            color: .blue,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        map.name = "exit"
        map.texture = SKTexture(imageNamed: "Button-Map")
        map.position = CGPoint(x: -map.size.width / 2 - scale(16), y: -y)
        map.zPosition = 1
        self.addChild(map)
        
        //X Btt
        let xBtt = SKSpriteNode(
            color: .red,
            size: CGSize(width: 46, height: 46)
        )
        xBtt.name = "resume"
        xBtt.texture = SKTexture(imageNamed: "Button-X")
        xBtt.position = CGPoint(x: size.width / 2 - 24 - xBtt.size.width / 2, y: size.height / 2 - 24 - xBtt.size.height / 2)
        xBtt.zPosition = 1
        self.addChild(xBtt)
    
        //Resume Btt
        let resume = SKSpriteNode(
            color: .green,
            size: CGSize(width: buttonSize * 2 + scale(32), height: buttonSize * 0.75 * 0.719)
        )
        resume.name = "resume"
        resume.texture = SKTexture(imageNamed: "Button-Resume")
        y = resetLevel.position.y + resetLevel.size.height / 2 + resume.size.height / 2
        resume.position = CGPoint(x: 0, y: y + scale(32))
        resume.zPosition = 1
        self.addChild(resume)

        let txtLabel = SKLabelNode(text: "CONTINUAR")
        txtLabel.fontSize = fontSize
        txtLabel.fontColor = .white
        txtLabel.fontName = "AvenirNext-Bold"
        txtLabel.verticalAlignmentMode = .center
        txtLabel.zPosition = 1
        resume.addChild(txtLabel)
        
        //Even
        let even = SKSpriteNode(
            color: .blue,
            size: CGSize(width: scale(280) * 0.84, height: scale(280))
        )
        even.name = "even"
        even.texture = SKTexture(imageNamed: "Even-Pause")
        even.position = CGPoint(x: 0, y: scale(80))
        even.zPosition = 1
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
                switch node.name {
                case "exit":
                    exit()
                case "reset":
                    reset()
                case "resume":
                    resume()
                default:
                    break
                }
            }
        }
    }
    
    private func exit(){
        pauseDelegate?.exitLevel()
    }
    
    private func reset(){
        pauseDelegate?.resetLevel()
    }
    
    private func resume(){
        pauseDelegate?.resumeLevel()
        self.removeFromParent()
    }
}
