//
//  ConfigurationViewController.swift
//  GameEven
//
//  Created by Jader Rocha on 25/11/20.
//

import UIKit

class ConfigurationViewController: UIViewController {
    
    private var audioPlayer = AudioManager.sharedInstance
    
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        changeSoundButtonImage()
        changeMusicButtonImage()
        
    }
    
    @IBAction func turnMusicOnOff(_ sender: Any) {
        audioPlayer.turnMusicOnOff()
        changeMusicButtonImage()
        audioPlayer.playMusic()
        
    }
    
    @IBAction func turnSoundOnOff(_ sender: Any) {
        audioPlayer.turnSoundOnOff()
        changeSoundButtonImage()
        audioPlayer.playSound(SoundType: .win)
    }
    
    @IBAction func resetProgress(_ sender: Any) {
        
    }
    
    func changeSoundButtonImage() {
        if audioPlayer.seeSoundOption() {
            soundButton.setImage(UIImage.init(named: "Som"), for: .normal)
        } else {
            soundButton.setImage(UIImage.init(named: "SomMudo"), for: .normal)
        }
    }
    
    func changeMusicButtonImage() {
        if audioPlayer.seeMusicOption() {
            musicButton.setImage(UIImage.init(named: "Musica"), for: .normal)
        } else {
            musicButton.setImage(UIImage.init(named: "MusicaMuda"), for: .normal)
        }
    }
}
    
