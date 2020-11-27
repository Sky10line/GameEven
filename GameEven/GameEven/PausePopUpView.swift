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
    
    private var balloon: SKSpriteNode!
    
    private var musicBtt: SKSpriteNode!
    private var soundBtt: SKSpriteNode!
    private var xBtt: SKSpriteNode!
    
    private var buttonSize: CGFloat!
    private var fontSize: CGFloat!
    
    private var audioPlayer = AudioManager.sharedInstance
    
    init(size: CGSize){
        
        super.init(texture: nil, color: .orange, size: size)
        texture = SKTexture(imageNamed: "Background-Fases")
        
        isUserInteractionEnabled = true
        
        buttonSize = scale(90)
        fontSize = scale(40)
        
        balloon = SKSpriteNode()
        balloon.texture =  SKTexture(imageNamed: "Backgroud-PopUp")
        balloon.size = CGSize(width: size.width * 0.85, height: size.height * 0.75)
        balloon.position = position
        balloon.zPosition = 1
        self.addChild(balloon)
        
        //Reset Btt
        let resetLevel = SKSpriteNode(
            color: .red,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        resetLevel.name = "reset"
        var y: CGFloat = balloon.size.height / 2 - resetLevel.size.height / 2 - scale(64)
        resetLevel.texture = SKTexture(imageNamed: "Button-Reset")
        resetLevel.position = CGPoint(x: resetLevel.size.width / 2 + scale(16), y: -y)
        resetLevel.zPosition = 1
        balloon.addChild(resetLevel)
        
        //Exit to Map Btt
        let map = SKSpriteNode(
            color: .blue,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        map.name = "exit"
        map.texture = SKTexture(imageNamed: "Button-Map")
        map.position = CGPoint(x: -map.size.width / 2 - scale(16), y: -y)
        map.zPosition = 1
        balloon.addChild(map)
        
        //X Btt
        xBtt = SKSpriteNode(
            color: .red,
            size: CGSize(width: 44, height: 44)
        )
        xBtt.name = "resume"
        xBtt.texture = SKTexture(imageNamed: "Button-X")
        xBtt.position = CGPoint(x: balloon.size.width / 2 - 24 - xBtt.size.width / 2, y: balloon.size.height / 2 - 24 - xBtt.size.height / 2)
        xBtt.zPosition = 1
        balloon.addChild(xBtt)
    
        //Resume Btt
        let cont = NSLocalizedString("Continue", comment: "continue btn")
        
        let resume = SKSpriteNode(
            color: .green,
            size: CGSize(width: buttonSize * 2 + scale(32), height: buttonSize * 0.75 * 0.719)
        )
        resume.name = "resume"
        resume.texture = SKTexture(imageNamed: "Button-Resume")
        y = resetLevel.position.y + resetLevel.size.height / 2 + resume.size.height / 2
        resume.position = CGPoint(x: 0, y: y + scale(32))
        resume.zPosition = 1
        balloon.addChild(resume)

        let txtLabel = SKLabelNode(text: cont)
        txtLabel.fontSize = fontSize
        txtLabel.fontColor = .white
        txtLabel.fontName = "Even"
        txtLabel.verticalAlignmentMode = .center
        txtLabel.zPosition = 1
        resume.addChild(txtLabel)
        
        //Even
        let even = SKSpriteNode(
            color: .blue,
            size: CGSize(width: scale(220) * 0.857, height: scale(220))
        )
        even.name = "even"
        even.texture = SKTexture(imageNamed: "Even-Pause")
        even.position = CGPoint(x: 0, y: scale(30))
        even.zPosition = 1
        balloon.addChild(even)
        
        createSoundButtons()
        createMusicButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Passar criaçao de elementos para funcs
    //MARK: Elementos
    private func createSoundButtons() {
        soundBtt = SKSpriteNode(
            color: .red,
            size: CGSize(width: 46, height: 46)
        )
        soundBtt.name = "sound"
        toggleSound()
        soundBtt.position.y = xBtt.position.y - soundBtt.size.height * 2
        soundBtt.position.x = -soundBtt.size.width - 8
        soundBtt.zPosition = 1
        balloon.addChild(soundBtt)
    }
    
    private func createMusicButtons() {
        musicBtt = SKSpriteNode(
            color: .red,
            size: CGSize(width: 46, height: 46)
        )
        musicBtt.name = "music"
        toggleMusic()
        musicBtt.position.y = soundBtt.position.y
        musicBtt.position.x = musicBtt.size.width + 8
        musicBtt.zPosition = 1
        balloon.addChild(musicBtt)
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
    
    //MARK: Interacoes
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
                case "music":
                    turnMusicOnOff()
                case "sound":
                    turnSoundOnOff()
                default:
                    break
                }
            }
        }
    }
    
    private func turnMusicOnOff() {
        audioPlayer.turnMusicOnOff()
        toggleMusic()
        audioPlayer.playMusic()
            
    }
    
    private func turnSoundOnOff() {
        audioPlayer.turnSoundOnOff()
        toggleSound()
        audioPlayer.playSound(SoundType: .win)
    }
    
    // Método pra trocar a imagem do botão de música
    private func toggleMusic() {
        if audioPlayer.seeMusicOption() {
            musicBtt.texture = SKTexture(imageNamed: "Musica")
        } else {
            musicBtt.texture = SKTexture(imageNamed: "MusicaMuda")
        }
    }
    
    // Método pra trocar a imagem do botão de som
    private func toggleSound(){
        if audioPlayer.seeSoundOption() {
            soundBtt.texture = SKTexture(imageNamed: "Som")
        } else {
            soundBtt.texture = SKTexture(imageNamed: "SomMudo")
        }
    }
    //Delegate
    private func exit(){
        pauseDelegate?.exitLevel()
        print("Pause Exit func")
    }
    
    private func reset(){
        pauseDelegate?.resetLevel()
        print("Pause Reset func")
    }
    
    private func resume(){
        print("Pause Resume func")
        pauseDelegate?.resumeLevel()
        self.run(  .fadeAlpha(to: 0, duration: 0.3)) {
            self.removeFromParent()
        }
    }
}
