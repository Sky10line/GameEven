//
//  ConfirmationView.swift
//  GameEven
//
//  Created by Rogerio Lucon on 26/11/20.
//

import UIKit

protocol ConfirmeDelegate: class {
    func confirme()
    func cancel(sender: Any)
}

class ConfirmationView: UIView {
    
    @IBOutlet weak var label: UILabel!
    
    weak var delegate: ConfirmeDelegate?
    
    var audioPlayer = AudioManager.sharedInstance
    
    var mensage: String = "" { didSet { label.text = mensage } }
    
    @IBOutlet weak var whiteBaloon: UIImageView!
    @IBOutlet weak var evenImage: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    
    @IBAction func confirme(_ sender: Any) {
        audioPlayer.playSound(SoundType: .button)
        delegate?.confirme()
    }
    
    @IBAction func cancel(_ sender: Any) {
        audioPlayer.playSound(SoundType: .button)
        delegate?.cancel(sender: self)
    }
    
    @IBAction func exit(_ sender: Any) {
        audioPlayer.playSound(SoundType: .button)
        delegate?.cancel(sender: self)
    }
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
//        let viewFromXib = Bundle.main.loadNibNamed("ConfirmationView", owner: self, options: nil)![0] as! ConfirmationView
        self.frame = self.bounds
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
//        addSubview(viewFromXib)
    }
    
    func resizeObjects() {
        
        confirmButton.setTitle(NSLocalizedString("Confirm", comment: "initial instruction"), for: .normal)
        
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "initial instruction"), for: .normal)
        
        
        
        self.evenImage.frame = self.evenImage.frame.resizeWithAspectRatio(extraScale: 1)
        
        for object in [self.confirmButton,self.cancelButton] {
            
            let scale = object!.frame.height
            
            object?.frame = (object?.frame.resizeWithAspectRatio(extraScale: 1))!
            
            object?.titleLabel?.font = object?.titleLabel?.font.withSize((object!.frame.height/scale)*(object?.titleLabel?.font.pointSize)!)
        }
        
        let scale = self.label.frame.height

        self.label.frame = self.label.frame.resizeWithAspectRatio(extraScale: 1)
        
        self.label.font = self.label.font.withSize((self.label.frame.height/scale)*(self.label.font.pointSize)+4)
        
        
        //self.confirmButton.frame = self.confirmButton.frame.resizeWithAspectRatio(extraScale: 1)
        //self.cancelButton.frame = self.cancelButton.frame.resizeWithAspectRatio(extraScale: 1)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ConfirmationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}
