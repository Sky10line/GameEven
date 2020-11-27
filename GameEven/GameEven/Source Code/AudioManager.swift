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
    
    private init() {
        initMusic()
    }
    
//    static var sharedInstance: AudioManager = {
//        let instance = AudioManager()
//
//        return instance
//    }
    
    static let sharedInstance: AudioManager = { AudioManager() }()
    
    var musicPlayer: AVAudioPlayer?
    var soundPlayer: AVAudioPlayer?
    
    func playSound(SoundType: Sounds) {
        if seeSoundOption() {
            soundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: SoundType.rawValue, ofType: "mp3")!))
            soundPlayer?.play()
        }
    }
    
    func turnSoundOnOff() {
        if soundPlayer?.isPlaying == true {
            soundPlayer?.stop()
        }
        UserDefaults.standard.changeSoundOption()
    }
    
    func seeSoundOption() -> Bool {
        return UserDefaults.standard.isSoundOption()
    }
    
    func initMusic() {
        try? AVAudioSession.sharedInstance().setMode(.default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func playMusic() {
        if seeMusicOption() {
            musicPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: Sounds.music.rawValue, ofType: "mp3")!))
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.play()
        }
    }
    
    func turnMusicOnOff() {
        musicPlayer?.stop()
        if musicPlayer?.isPlaying == true {
            musicPlayer?.stop()
        }
        UserDefaults.standard.changeMusicOption()
    }
    
    func seeMusicOption() -> Bool {
        return UserDefaults.standard.isMusicOption()
    }
}
