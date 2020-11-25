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
    private var str:[String] = ["Lorem Ipsum is simply dummy text of Primeira parte is simply dummy text of the printing","printing and typesetting industry. is simply dummy text of the printing Lorem Segunda parte", "is simply dummy text of the printing It has survived not only five centuries, but also the leap Terceira parte", "is simply dummy text of the printing It has survived not only five centuries, but also the leap Terceira parte", "is simply dummy text of the printing It has survived not only five centuries, but also the leap Terceira parte", "is simply dummy text of the printing It has survived not only five centuries, but also the leap Terceira parte", "is simply dummy text of the printing It has survived not only five centuries, but also the leap Terceira parte", "is simply dummy text of the printing It has survived not only five centuries, but also the leap Terceira parte", "is simply dummy text of the printing It has survived not only five centuries, but also the leap Terceira parte", "is simply dummy text of the printing It has survived not only five centuries, but also the leap Terceira parte", "is simply dummy text of the printing It has survived not only five centuries, but also the leap Terceira parte"]
    private var index = 0
    private var counter = 0
    private var speed: Double = 60
    private var fontSize: CGFloat = 25
    private var timer: Timer?
    private var auxText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.sizeToFit()
        label.font = UIFont(name: "Even", size: fontSize)
        label.textColor = .black
        label.text = ""
        label.isEditable = false
        imageView.image = UIImage(named: "Onboard-\(index + 1)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
                print(index + 1)
            } else {
                performSegue(withIdentifier: "Map", sender: self)
            }
            
        } else {
            counter = str[index].count
        }
    }
}
