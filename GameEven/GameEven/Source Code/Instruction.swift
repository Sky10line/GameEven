//
//  Instruction.swift
//  GameEven
//
//  Created by Jader Rocha on 29/10/20.
//

import UIKit
import SpriteKit
import GameplayKit

class InstructionViewController: UIViewController {
    
    @IBOutlet weak var returnButton: UIButton!
    
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var instructionText: UILabel!
    
    var selectedPhase: Int = 0 // Fase que o jogador selecionou
    
    override func viewDidLoad() {
        
        overrideUserInterfaceStyle = .dark
        
        instructionText.text = readPhaseInstruction()
        
        okButton.addTarget(self, action: #selector(enterInPhase), for: .touchUpInside)
        
        super.viewDidLoad()
        
        UserDefaults.standard.savePlayerLevel(playerLevel: selectedPhase + 1)
        
    }
    
    // Método que retornará o texto da instrução.
    func readPhaseInstruction() -> String {
        
        return "\(selectedPhase)"
    }
    
    // Método que abrirá a fase
    @objc func enterInPhase(sender: UIButton!) {
        
        print("Entrando na fase \(selectedPhase)")
        
        performSegue(withIdentifier: "Game", sender: sender.tag)
        
    }
}
