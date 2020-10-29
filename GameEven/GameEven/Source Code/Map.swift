//
//  Map.swift
//  GameEven
//
//  Created by Jader Rocha on 28/10/20.
//

import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet var buttonWay: [UIButton]! // Array com todos os botões da fase.
    
    var playerPhase: Int = 1 // Int com a fase em que o jogador está.
    
    override func viewDidLoad() {
        
        // Ordena de forma crescente o vetor de botões pela tag de cada botão.
        buttonWay.sort {
            $0.tag < $1.tag
        }
        
        // Caso a fase do jogador esteja acima da contagem de botões, ele retorna ao número de fases existentes.
        if playerPhase > buttonWay.count { playerPhase = buttonWay.count }
        
        // Baseado na fase em que o jogador está, modifica os botões das fases anteriores e da atual.
        buttonWay[(0..<playerPhase)].forEach {
            
            $0.addTarget(self, action: #selector(enterInPhase), for: UIControl.Event.touchUpInside)
        }
        
        super.viewDidLoad()
    }
    
    // Função para o jogador entrar na fase referente a .tag do botão.
    @objc func enterInPhase(sender: UIButton!) {
        
        print(sender.tag)
    }
}
