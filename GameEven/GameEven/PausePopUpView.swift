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
    private var even: SKSpriteNode!
    private var resetLevel: SKSpriteNode!
    private var map: SKSpriteNode!
    private var resumeBtt: SKSpriteNode!
    
    private var buttonSize: CGFloat!
    private var fontSize: CGFloat!
    
    private var scale: CGFloat! = 0
    
    private var audioPlayer = AudioManager.sharedInstance
    
    init(size: CGSize){
        
        super.init(texture: nil, color: .orange, size: size)
        texture = SKTexture(imageNamed: "Background-Fases")
        scale = scaleValue()
        isUserInteractionEnabled = true
        
        buttonSize = 90
        fontSize = 40 * scale
        
        createBalloon()
        
        createXbutton()
        
        createResetBtt()
        
        createMapBtt()
        
        createResumeBtt()
        
        createEven()
        
        createSoundButtons()
        
        createMusicButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Elementos
    private func createBalloon() {
        balloon = SKSpriteNode()
        balloon.texture =  SKTexture(imageNamed: "Backgroud-PopUp")
        balloon.size = CGSize(width: size.width * 0.85, height: size.height * 0.75)
        balloon.position = position
        balloon.zPosition = 1
        self.addChild(balloon)
    }
    
    private func createXbutton() {
        xBtt = SKSpriteNode(
            color: .red,
            size: CGSize(width: 44, height: 44)
        )
        xBtt.name = "resume"
        xBtt.texture = SKTexture(imageNamed: "Button-X")
        xBtt.position = CGPoint(x: balloon.size.width / 2 - 24 - xBtt.size.width / 2, y: balloon.size.height / 2 - 24 - xBtt.size.height / 2)
        xBtt.zPosition = 1
        balloon.addChild(xBtt)
    }
    
    private func createSoundButtons() {
        soundBtt = SKSpriteNode(
            color: .red,
            size: CGSize(width: 46, height: 46)
        )
        soundBtt.name = "sound"
        toggleSound()
        soundBtt.position.y = xBtt.position.y - soundBtt.size.height * (2 * scale)
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
    
    private func createEven(){
        even = SKSpriteNode(
            color: .blue,
            size: CGSize(width: 220 * 0.857, height: 220)
        )
        
        even.name = "even"
        even.texture = SKTexture(imageNamed: "Even-Pause")
        even.position = CGPoint(x: 0, y: 20)
        even.zPosition = 1
        even.resizeble(true)
        balloon.addChild(even)
    }
    
    private func createResetBtt() {
        
        resetLevel = SKSpriteNode(
            color: .red,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        resetLevel.name = "reset"
        var y: CGFloat = (balloon.size.height / 2) - (resetLevel.size.height / 2)
        y -= (64 * scale)
        resetLevel.texture = SKTexture(imageNamed: "Button-Reset")
        resetLevel.resizeble()
        resetLevel.position = CGPoint(x: resetLevel.size.width / 2 + 16 * scale, y: -y)
        resetLevel.zPosition = 1
       
        balloon.addChild(resetLevel)
    }
    
    private func createMapBtt() {
        map = SKSpriteNode(
            color: .blue,
            size: CGSize(width: buttonSize, height: buttonSize * 0.719)
        )
        map.name = "exit"
        map.texture = SKTexture(imageNamed: "Button-Map")
        map.resizeble()
        map.position = CGPoint(x: -map.size.width / 2 - 16 * scale, y: resetLevel.position.y)
        map.zPosition = 1

        balloon.addChild(map)
    }
    
    private func createResumeBtt(){
        //Resume Btt
        let cont = NSLocalizedString("Continue", comment: "continue btn")
        
        resumeBtt = SKSpriteNode(
            color: .green,
            size: CGSize(width: buttonSize * 2 + 32, height: buttonSize * 0.75 * 0.719)
        )
        resumeBtt.name = "resume"
        resumeBtt.resizeble()
        resumeBtt.texture = SKTexture(imageNamed: "Button-Resume")
        let y = resetLevel.position.y + resetLevel.size.height / 2 + resumeBtt.size.height / 2
        resumeBtt.position = CGPoint(x: 0, y: y + 32 * scale)
        resumeBtt.zPosition = 1
        
        balloon.addChild(resumeBtt)

        let txtLabel = SKLabelNode(text: cont)
        txtLabel.fontSize = fontSize
        txtLabel.fontColor = .white
        txtLabel.fontName = "Even"
        txtLabel.verticalAlignmentMode = .center
        txtLabel.zPosition = 1
        resumeBtt.addChild(txtLabel)
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
        audioPlayer.playSound(SoundType: .button)
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
        audioPlayer.playSound(SoundType: .button)
        pauseDelegate?.exitLevel()
    }
    
    private func reset(){
        audioPlayer.playSound(SoundType: .button)
        pauseDelegate?.resetLevel()
    }
    
    private func resume(){
        audioPlayer.playSound(SoundType: .button)
        pauseDelegate?.resumeLevel()
        self.run(  .fadeAlpha(to: 0, duration: 0.3)) {
            self.removeFromParent()
        }
    }
}
