//
//  AudioManager.swift
//  GameEven
//
//  Created by Jader Rocha on 20/11/20.
//

import AVFoundation
import Foundation

enum Sounds: String {
    case music = "NotOfficialMusic"
    case placePiece = "NotOfficialPlacePiece"
    case win = "NotOfficialWin"
}

class AudioManager {
    
    var musicPlayer: AVAudioPlayer?
    var soundPlayer: AVAudioPlayer?

    init() {
        initMusic()
    }
    
    // Função para saber se há música tocando no momento
    func statusMusic() -> Bool {
        return musicPlayer?.isPlaying ?? false
    }
    
    func playMusic() {
        guard let safePlayer = musicPlayer else { return }
        //Manda ele tocar a música
        safePlayer.currentTime = 0
        safePlayer.play()
    }
    
    // Método que desliga/liga a música sempre que chamada
    
    func playStopMusic() {
        
        UserDefaults.standard.setMuteMusic()
        
        if statusMusic() == true {
            
            musicPlayer?.stop()
            
        } else {
            
            playMusic()
            
        }
    }
    
    func initMusic(){
        // Caminho até o áudio e tipo de arquivo
        let musicUrlString = Bundle.main.path(forResource: Sounds.music.rawValue, ofType: "mp3")
        
        do {
            //Não entendi direito isso, mas pelo visto é útil
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let safeUrlString = musicUrlString else { return }
            
            //Passa o áudio para o player
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: safeUrlString))
            
            //Toca infinitamente
            musicPlayer?.numberOfLoops = -1
            
            
        } catch {
            print("Erro na música")
        }
    }
    
    func playSound(SoundType: Sounds) {
        soundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: SoundType.rawValue, ofType: "mp3")!))
        soundPlayer?.play()
    }
}
