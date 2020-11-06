//
//  Map.swift
//  GameEven
//
//  Created by Jader Rocha on 28/10/20.
//

import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet var buttonWay: [UIButton]! // Array com todos os botões da fase.
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var playerPhase: Int = 1// Int com a fase em que o jogador está
    
    override func viewWillAppear(_ animated: Bool) {
        loadingPlayerLevel()
        
        initButtons()
        
        print(UserDefaults.standard.loadPlayerLevel())
    }
    
    override func viewDidLoad() {
        
        overrideUserInterfaceStyle = .dark
        repeatingBackground()

        super.viewDidLoad()
    }
    
    
    // Método que carrega em que nível está o jogador baseado no userDefault, define como 1 caso não encontre nada.
    func loadingPlayerLevel() {
        
        playerPhase = UserDefaults.standard.loadPlayerLevel()
        playerPhase == 0 ? playerPhase = 1 : ()
        
    }
    
    // Método que colore a scrollView com a imagem do background de maneira repetida.
    func repeatingBackground() {
        let image = UIImage(named: "BackG_Mapa")!

        let scaled = UIImage(cgImage: image.cgImage!, scale: UIScreen.main.scale*(image.size.width/(UIScreen.main.bounds.width*2)), orientation: image.imageOrientation)


        scrollView.backgroundColor = UIColor(patternImage: scaled)
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
