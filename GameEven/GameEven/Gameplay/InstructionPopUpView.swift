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
    
    init(size: CGSize){
        
        super.init(texture: nil, color: .orange, size: size)
        
        self.color = .gray
//        texture = SKTexture(imageNamed: "Backgroud-PopUp")
        
        isUserInteractionEnabled = true
        
        buttonSize = scale(90)
        fontSize = scale(28)
        let offset = scale(100)
        let ballon = SKSpriteNode(
            color: .red,
            size: CGSize(width: scale(320), height: scale(400))
        )
        ballon.texture = SKTexture(imageNamed: "InstructionBallon")
        ballon.position = CGPoint(x: 0, y: ballon.size.height / 2 + 8 - offset)
        ballon.zPosition = 1
        ballon.color = .green
        self.addChild(ballon)

        //X Btt
        let xBtt = SKSpriteNode(
            color: .red,
            size: CGSize(width: 46, height: 46)
        )
        xBtt.name = "back"
        xBtt.texture = SKTexture(imageNamed: "Button-X")
        xBtt.position = CGPoint(x: ballon.size.width/2 - xBtt.size.width / 2 - 16, y: ballon.size.height/2 - xBtt.size.height / 2 - 16)
        xBtt.zPosition = 1
        ballon.addChild(xBtt)
        
        //Ok Btt
        let okBtt = SKSpriteNode(
            color: .red,
            size: CGSize(width: 46, height: 46)
        )
        okBtt.name = "ok"
        okBtt.texture = SKTexture(imageNamed: "Button-X")
        okBtt.position = CGPoint(x: 0, y: 16  - ballon.size.height/4 + xBtt.size.height / 2 )
        okBtt.zPosition = 1
        ballon.addChild(okBtt)
        
        //Text

        //Even
        let even = SKSpriteNode(
            color: .blue,
            size: CGSize(width: scale(280) * 0.84, height: scale(280))
        )
        even.name = "even"
        even.texture = SKTexture(imageNamed: "InstructionEven")
        even.position = CGPoint(x: scale(68), y: -even.size.height / 2 - offset)
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
        
        print("Pause Exit func")
    }
    
    private func reset(){
        
        print("Pause Reset func")
    }
    
    private func resume(){
        print("Pause Resume func")

        self.run(  .fadeAlpha(to: 0, duration: 0.3)) {
            self.removeFromParent()
        }
    }
}
