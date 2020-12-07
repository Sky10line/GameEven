//
//  TextWriter.swift
//  TesteExemplosFuncinalidades
//
//  Created by Rogerio Lucon on 07/04/20.
//  Copyright © 2020 Rogerio Lucon. All rights reserved.
//

import UIKit
import AVFoundation

class OnboardViewController: UIViewController {
    
    @IBOutlet weak var label: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var txt = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
    private var str:[String] = []
    private var index = 0
    private var counter = 0
    private var speed: Double = 60
    private var fontSize: CGFloat = 25
    private var timer: Timer?
    private var auxText: String = ""
    
    private var isPause: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var audioPlayer = AudioManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer.musicPlayer?.prepareToPlay()
        audioPlayer.soundPlayer?.prepareToPlay()
        
        label.sizeToFit()
        label.font = UIFont(name: "Even", size: fontSize)
        label.textColor = .black
        label.text = ""
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.nextLineScript))
        label.addGestureRecognizer(tap)
        label.isSelectable = false
        imageView.image = UIImage(named: "Onboard-\(index + 1)")
        
        for i in 1...20 {
            str.append(NSLocalizedString("Parte \(i)", comment: ""))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if audioPlayer.musicPlayer?.isPlaying != true || audioPlayer.musicPlayer == nil {
            audioPlayer.playMusic()
        }
        
        super.viewDidAppear(animated)
        typeWriter()
    }

    
    @objc func typeWriter(){
        if counter < str[index].count {
            let array = Array(str[index])
            auxText = auxText +  String(array[counter])
            label.text = auxText
            let interval = Double((arc4random_uniform(8) + 1)) / speed
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(typeWriter), userInfo: nil, repeats: true)
        } else if counter == str[index].count {
            label.text = str[index]
            timer?.invalidate()
        } else {
            timer?.invalidate()
        }
        counter += 1
    }
    
    @objc func nextLineScript(){
        if counter > str[index].count {
            
            if index < str.count - 1{
                counter = 0
                index = index + 1
                label.text = ""
                auxText = ""
                typeWriter()
                
                UIView.transition(with: imageView, duration: 1.0, options: .curveEaseInOut, animations: {
                    self.imageView.image = UIImage(named: "Onboard-\(self.index + 1)")
                }, completion: nil)
            } else {
                goToMap()
            }
            
        } else {
            counter = str[index].count
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPause {
            return
        }
        nextLineScript()
    }
    
    @IBAction func skipBtt(_ sender: Any) {
        audioPlayer.playSound(SoundType: .button)
        isPause = true
        let XibView = ConfirmationView.instanceFromNib()
        
        UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromRight, animations: {
            self.view.addSubview(XibView)
        }, completion: nil)
        
        if let confirmeView: ConfirmationView = XibView as? ConfirmationView {
            confirmeView.delegate = self
            confirmeView.mensage = "Tem certeza que deseja pular a introdução?"
        }
    }
    
    private func goToMap(){
        performSegue(withIdentifier: "Map", sender: self)
    }
}

extension OnboardViewController: ConfirmeDelegate {
    func confirme() {
        goToMap()
    }
    
    func cancel(sender: Any) {
        guard let sender = sender as? UIView else {
            fatalError("Sender")
        }
        
        UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromLeft, animations: {
            sender.removeFromSuperview()
        }, completion: { _ in
             self.isPause = false
        })
        
    }
    
    
}
