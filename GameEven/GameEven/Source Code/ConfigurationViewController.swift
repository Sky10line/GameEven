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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        resetButton.setTitle(NSLocalizedString("Reset", comment: "initial instruction"), for: .normal)
        
        changeSoundButtonImage()
        changeMusicButtonImage()
        
    }
    
    @IBAction func returnBtnSound(_ sender: Any) {
        audioPlayer.playSound(SoundType: .button)
    }
    
    @IBAction func turnMusicOnOff(_ sender: Any) {
        audioPlayer.turnMusicOnOff()
        changeMusicButtonImage()
        audioPlayer.playMusic()
        
    }
    
    @IBAction func turnSoundOnOff(_ sender: Any) {
        audioPlayer.turnSoundOnOff()
        changeSoundButtonImage()
        audioPlayer.playSound(SoundType: .button)
    }
    
    // Método pra trocar a imagem do botão de som
    func changeSoundButtonImage() {
        if audioPlayer.seeSoundOption() {
            soundButton.setImage(UIImage.init(named: "Som"), for: .normal)
        } else {
            soundButton.setImage(UIImage.init(named: "SomMudo"), for: .normal)
        }
    }
    
    // Método pra trocar a imagem do botão de música
    func changeMusicButtonImage() {
        if audioPlayer.seeMusicOption() {
            musicButton.setImage(UIImage.init(named: "Musica"), for: .normal)
        } else {
            musicButton.setImage(UIImage.init(named: "MusicaMuda"), for: .normal)
        }
    }
    
    @IBAction func resetProgress(_ sender: Any) {
        audioPlayer.playSound(SoundType: .button)
        let XibView = ConfirmationView.instanceFromNib()
        
        UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromRight, animations: {
            self.view.addSubview(XibView)
            XibView.frame = self.view.bounds
        }, completion: nil)
        
        if let confirmeView: ConfirmationView = XibView as? ConfirmationView {
            //confirmeView.resizeObjects()
            //confirmeView.whiteBaloon.frame = confirmeView.whiteBaloon.frame.resizeWithAspectRatio()
            confirmeView.delegate = self
            confirmeView.resizeObjects()
            confirmeView.mensage = (NSLocalizedString("resetProgress", comment: "initial instruction"))
            //confirmeView.whiteBaloon.frame = confirmeView.whiteBaloon.frame.resizeWithAspectRatio()
        }
    }
    
    private func backToMap() {
        performSegue(withIdentifier: "unwindToMap", sender: self)
    }
    
    private func resetProgress() {
        UserDefaults.standard.resetPlayerLevel()
    }
}

extension ConfigurationViewController: ConfirmeDelegate {
    func confirme() {
        resetProgress()
        backToMap()
    }
    
    func cancel(sender: Any) {
        guard let sender = sender as? UIView else {
            fatalError("Sender")
        }
        
        UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromLeft, animations: {
            sender.removeFromSuperview()
        }, completion: nil)
        
    }
}
    
