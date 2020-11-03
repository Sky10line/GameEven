//
//  Map.swift
//  GameEven
//
//  Created by Jader Rocha on 28/10/20.
//

import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet var buttonWay: [UIButton]! // Array com todos os botões da fase.
    
    var playerPhase: Int = 5 // Int com a fase em que o jogador está
    
    override func viewDidLoad() {
        
        overrideUserInterfaceStyle = .dark
        
        initButtons()

        super.viewDidLoad()
    }
    
    // Método que baseado na fase em que o jogador está, modifica os botões das fases anteriores e da atual.
    func initButtons() {

        buttonWay.forEach { (button) in
            
            // Ajusta o texto do botão para aparecer em 1/4 da altura
            button.titleEdgeInsets = UIEdgeInsets(top: ((button.frame.height) / 4)-5, left: 0, bottom: 0, right: 0)
            
            if (button.tag <= playerPhase) {
                
                button.setBackgroundImage(UIImage.init(named: "BlueMapButton"), for: .normal)
                button.addTarget(self, action: #selector(enterInInstruction), for: .touchUpInside)
            }
        }
    }
    
    // Método para o jogador entrar na fase referente a .tag do botão.
    @objc func enterInInstruction(sender: UIButton!) {
        
        performSegue(withIdentifier: "goToInstruction", sender: sender.tag)
    }
    
    // Função que passará a fase e chamará a próxima tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToInstruction") {
            guard let instructionView = segue.destination as? InstructionViewController else { return }
            
            instructionView.selectedPhase = sender as! Int
        }
    }
    
    // Método retornar ao mapa
    @IBAction func unwindToMap(_ sender: UIStoryboardSegue) {}
    
}
