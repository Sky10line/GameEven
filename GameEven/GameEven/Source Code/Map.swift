//
//  Map.swift
//  GameEven
//
//  Created by Jader Rocha on 28/10/20.
//

import UIKit

class MapViewController: UIViewController {
    
    
    // MARK: Variáveis
    
    // Objetos da ViewController
    
    @IBOutlet var buttonWay: [UIButton]! // Array com todos os botões da fase.
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    
    // Variáveis Lógicas
    
    var currentPlayerLevel: Int = 1 // Int com o nível de fases atual do jogador
    
    var scrollFirstTime: Bool = true
    
    // MARK: Ciclo de Vida da View
    
    override func viewWillAppear(_ animated: Bool) {
        
        overrideUserInterfaceStyle = .dark
        
        loadingPlayerLevel()
        
        initButtons()
        
    }
    
    override func viewDidLoad() {
        
        UserDefaults.standard.resetPlayerLevel()
        
        repeatingBackground()
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        autoScrollToLevel()
        
    }

    //MARK: Métodos de Lógica Interna
    
    // Método que carrega em que nível está o jogador baseado no userDefault, define como 1 caso não encontre nada.
    func loadingPlayerLevel() {
        
        currentPlayerLevel = UserDefaults.standard.loadPlayerLevel()
        currentPlayerLevel == 0 ? currentPlayerLevel = 1 : ()
    }
    
    //MARK: Métodos de Definição do Layout
    
    // Método que colore a scrollView com a imagem do background de maneira repetida.
    func repeatingBackground() {
        
        let image = UIImage(named: "BackG_Mapa")!
        
        let scaled = UIImage(cgImage: image.cgImage!, scale: UIScreen.main.scale*(image.size.width/(UIScreen.main.bounds.width*2)), orientation: image.imageOrientation)
        
        backgroundScrollView.backgroundColor = UIColor(patternImage: scaled)
    }
    
    // Método que baseado no nível de fases do jogador, modifica os botões das fases anteriores e da atual.
    func initButtons() {
        
        buttonWay.forEach { (button) in
            
            // Ajusta o texto do botão para aparecer em 1/4 da altura.
            button.titleEdgeInsets = UIEdgeInsets(top: ((button.frame.height) / 4)-7.5, left: 0, bottom: 0, right: 0)
            
            if (button.tag <= currentPlayerLevel) {
                
                button.setBackgroundImage(UIImage.init(named: "BlueMapButton"), for: .normal)
                button.addTarget(self, action: #selector(enterInInstruction), for: .touchUpInside)
            }
        }
    }
    
    func autoScrollToLevel() {
        
        let screenSize = backgroundScrollView.frame.midY
        let scrollSize = backgroundScrollView.contentSize.height - (screenSize * 2)
        let yButtonPosition = buttonWay.first(where: {$0.tag == currentPlayerLevel})?.frame.midY ?? screenSize
        let centralizedScreenPosition = yButtonPosition - screenSize + scrollSize/2
        
        if scrollFirstTime {
            backgroundScrollView.contentInsetAdjustmentBehavior = .never
            backgroundScrollView.contentOffset.y = scrollSize
            scrollFirstTime = false
        }
        
        if centralizedScreenPosition < 0.0 {
            animateScroll(position: 0.0)
            
        } else if centralizedScreenPosition > scrollSize {
            animateScroll(position: scrollSize)
            
        } else {
            animateScroll(position: centralizedScreenPosition)
        }
    }
    
    func animateScroll(position: CGFloat) {
        
        UIView.animate(withDuration: 1.25, delay: 0.0, animations: {
            self.backgroundScrollView.contentOffset.y = position
        })
    }
    
    //MARK: Entrada e Saída da View
    
    // Método para o jogador entrar na fase referente a .tag do botão.
    @objc func enterInInstruction(sender: UIButton!) {
        performSegue(withIdentifier: "goToInstruction", sender: sender.tag)
    }
    
    // Função que passará a fase selecionada e chamará a próxima tela.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToInstruction") {
            guard let instructionView = segue.destination as? InstructionViewController else { return }
            
            instructionView.selectedPhase = sender as! Int
        }
    }
    
    // Método retornar ao mapa.
    @IBAction func unwindToMap(_ sender: UIStoryboardSegue) {}
    
}
