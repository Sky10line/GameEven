//
//  ConfirmationView.swift
//  GameEven
//
//  Created by Rogerio Lucon on 26/11/20.
//

import UIKit

protocol ComfirmeDelegate: class {
    func confirme()
    func cancel()
}

class ConfirmationViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    weak var delegate: ComfirmeDelegate?
    
    var mensage: String = "" { didSet { label.text = mensage } }
    
    override func viewDidLoad() {
        label.text = mensage
        
    }
    @IBAction func confirme(_ sender: Any) {
        delegate?.confirme()
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.cancel()
    }
    
    @IBAction func exit(_ sender: Any) {
        delegate?.cancel()
    }
}
