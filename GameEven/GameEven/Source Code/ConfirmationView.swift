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
    
    var mensage: String = "" { didSet { label.text = mensage } }
    
    @IBAction func confirme(_ sender: Any) {
        delegate?.confirme()
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.cancel(sender: self)
    }
    
    @IBAction func exit(_ sender: Any) {
        delegate?.cancel(sender: self)
    }
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
//        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        commonInit()
    }
    
    private func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("ConfirmationView", owner: self, options: nil)![0] as! ConfirmationView
        viewFromXib.frame = self.bounds
        viewFromXib.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(viewFromXib)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ConfirmationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
