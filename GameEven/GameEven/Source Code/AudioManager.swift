//
//  AudioManager.swift
//  GameEven
//
//  Created by Jader Rocha on 20/11/20.
//

import AVFoundation
import Foundation

enum Sounds: String {
    case music = "breakdown"
    case placePiece = "NotOfficialPlacePiece"
    case win = "NotOfficialWin"
}

class AudioManager {
    
    private init() {
        initMusic()
    }
    
    // Utilizar para sempre iniciar a mesma intância da classe
    static let sharedInstance: AudioManager = { AudioManager() }()
    
    var musicPlayer: AVAudioPlayer?
    var soundPlayer: AVAudioPlayer?
    
    // Método pra tocar um som
    func playSound(SoundType: Sounds) {
        if seeSoundOption() {
            soundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: SoundType.rawValue, ofType: "mp3")!))
            soundPlayer?.play()
        }
    }
    
    // Método pra ligar ou desligar o som
    func turnSoundOnOff() {
        if soundPlayer?.isPlaying == true {
            soundPlayer?.stop()
        }
        UserDefaults.standard.changeSoundOption()
    }
    
    // Função para ver se o som está mutado ou não
    func seeSoundOption() -> Bool {
        return UserDefaults.standard.isSoundOption()
    }
    
    func initMusic() {
        try? AVAudioSession.sharedInstance().setMode(.default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    // Método pra tocar uma música
    func playMusic() {
        if seeMusicOption() {
            musicPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: Sounds.music.rawValue, ofType: "wav")!))
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.play()
        }
    }
    
    // Método pra ligar ou desligar a música
    func turnMusicOnOff() {
        musicPlayer?.stop()
        if musicPlayer?.isPlaying == true {
            musicPlayer?.stop()
        }
        UserDefaults.standard.changeMusicOption()
    }
    
    // Função para ver se a música está mutada ou não
    func seeMusicOption() -> Bool {
        return UserDefaults.standard.isMusicOption()
    }
}
