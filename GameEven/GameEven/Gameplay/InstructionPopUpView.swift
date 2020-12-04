//
//  InstructionPopUpView.swift
//  GameEven
//
//  Created by Rogerio Lucon on 09/11/20.
//

import SpriteKit

class InstructionPopUpView: SKSpriteNode {
    
    
    private var buttonSize: CGFloat!
    private var fontSize: CGFloat!
    
    private var audioPlayer = AudioManager.sharedInstance
    
    var delegate: PauseMenuDelegate?
    
    init(size: CGSize, _ message: String){

        super.init(texture: nil, color: .clear, size: size)
        
        isUserInteractionEnabled = true
        
        let scale = scaleValue()
        
        buttonSize = 90 * scale
        fontSize = 28 * scale
        
        let bg = SKSpriteNode()
        bg.texture = SKTexture(imageNamed: "Background-Fases")
        bg.size = size
        bg.position = position
        self.addChild(bg)
        
        let offset = 100 * scale
        let ballon = SKSpriteNode(
            color: .red,
            size: CGSize(width: self.size.width - 64, height: 400 * scale)
        )

        ballon.texture = SKTexture(imageNamed: "InstructionBallon")
        ballon.position = CGPoint(x: 0, y: ballon.size.height / 2 + 8 - offset)
        ballon.zPosition = 1
        ballon.color = .green
        self.addChild(ballon)
        
        let message = NSLocalizedString(message, comment: "initial instruction")
        
        //Text
        let labelText = SKLabelNode()
        labelText.text = message
        labelText.zPosition = 1
        labelText.fontSize = fontSize
        labelText.fontColor = .black
        labelText.fontName = "Even"
        labelText.numberOfLines = 10
        labelText.preferredMaxLayoutWidth = ballon.size.width - 32
        labelText.lineBreakMode = .byCharWrapping
        labelText.verticalAlignmentMode = .center
        labelText.position.y = ballon.position.y - fontSize
        ballon.addChild(labelText)
        
//        Ajusta para textos maiores
//        if labelText.frame.height > 154 {
//            let dif = labelText.frame.height - 154
//            ballon.size.height = ballon.frame.height + dif
//            labelText.position.y = ballon.position.y + 32 + dif / 2
//        }
        
        //X Btt
        let xBtt = SKSpriteNode(
            color: .red,
            size: CGSize(width: 44, height: 44)
        )
        xBtt.name = "back"
        xBtt.texture = SKTexture(imageNamed: "Button-X")
        xBtt.position = CGPoint(x: ballon.size.width/2 - xBtt.size.width / 2 - 16, y: ballon.size.height/2 - xBtt.size.height / 2 - 16)
        xBtt.zPosition = 1
        ballon.addChild(xBtt)
        
        //Ok Btt
        let ok = NSLocalizedString("OK", comment: "OK btn")
        
        let okBtt = SKSpriteNode(
            color: .red,
            size: CGSize(width: 150, height: 50)
        )
        okBtt.resizeble()
        okBtt.name = "ok"
        okBtt.texture = SKTexture(imageNamed: "Button-Resume")
        okBtt.position = CGPoint(x: 0, y: 32  - ballon.size.height/4 + xBtt.size.height / 2 )
        okBtt.zPosition = 1
        ballon.addChild(okBtt)
        
        let labelOk = SKLabelNode()
        labelOk.text = ok
        labelOk.zPosition = 1
        labelOk.fontSize = fontSize
        labelOk.fontColor = .white
        labelOk.fontName = "Even"
        labelOk.verticalAlignmentMode = .center
        
        okBtt.addChild(labelOk)
        
        //Even
        let even = SKSpriteNode(
            color: .blue,
            size: CGSize(width: 330 * 0.84, height: 330)
        )
        even.resizeble()
        even.name = "even"
        even.texture = SKTexture(imageNamed: "InstructionEven-1")
        even.position = CGPoint(x: 48, y: -even.size.height / 2 - offset + 32)
        even.adjustPosition(x: true, y: false)
        even.zPosition = 2
        self.addChild(even)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Interacoes
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let touchedNodes = self.nodes(at: location)
            for node in touchedNodes.reversed() {
                switch node.name {
                case "back":
                    exit()
                case "ok":
                    resume()
                default:
                    break
                }
            }
        }
    }
    
    private func exit(){
        audioPlayer.playSound(SoundType: .button)
        delegate?.exitLevel()
    }
    
    private func resume(){
        audioPlayer.playSound(SoundType: .button)
        self.run(  .fadeAlpha(to: 0, duration: 0.3)) {
            self.removeFromParent()
            self.delegate?.resumeLevel()
        }
    }
}
