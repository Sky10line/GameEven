//
//  RedirectViewController.swift
//  GameEven
//
//  Created by Rogerio Lucon on 19/11/20.
//

import UIKit

class RedirectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let save = UserDefaults.standard.loadPlayerLevel()
        if save > 0 {
            performSegue(withIdentifier: "Map", sender: self)
        } else {
            performSegue(withIdentifier: "Onboarding", sender: self)
        }
    }
}
