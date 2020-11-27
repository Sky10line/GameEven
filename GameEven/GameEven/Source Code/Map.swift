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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        //UserDefaults.standard.resetPlayerLevel()
        
        repeatingBackground()
        
        backgroundScrollView.contentOffset.y = 252
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        autoScrollToLevel()
        
        //Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(autoScrollToLevel), userInfo: nil, repeats: false)
        
        
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
        
        print(UIScreen.main.scale)
        print(image.size.width)
        print(UIScreen.main.bounds.width)
        
        //scale: UIScreen.main.scale*(image.size.width/(UIScreen.main.bounds.width*UIScreen.main.scale)),
        
        let scaled = UIImage(cgImage: image.cgImage!, scale: UIScreen.main.scale * (image.size.width / (UIScreen.main.bounds.width * UIScreen.main.scale)), orientation: image.imageOrientation)
        
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
            } else  {
                button.setBackgroundImage(UIImage.init(named: "GrayMapButton"), for: .normal)
                button.removeTarget(nil, action: nil, for: .allEvents)
            }
        }
    }
    
    // Método que faz a rolagem automática do scroll até centralizar no botão da nível atual, respeitando os limites do scrollView.
    func autoScrollToLevel() {
        
        let screenSize = backgroundScrollView.frame.midY
        let scrollSize = backgroundScrollView.contentSize.height - (screenSize * 2)
        let yButtonPosition = buttonWay.first(where: {$0.tag == currentPlayerLevel})?.frame.midY ?? (screenSize + scrollSize/2)
        let centralizedScreenPosition = yButtonPosition - screenSize + scrollSize/2
        
        // Define a posição inicial da scroll para o final da scrollView, ocorre somente uma vez.
        if scrollFirstTime {
            //backgroundScrollView.contentInsetAdjustmentBehavior = .never
            //backgroundScrollView.contentOffset.y = scrollSize
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
    
    // Método que anima a movimentação do scroll até chegar ao nível atual.
    func animateScroll(position: CGFloat) {
        UIView.animate(withDuration: 1.00, delay: 0.10, animations: {
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
            guard let instructionView = segue.destination as? GameViewController else { return }
            
            instructionView.level = sender as! Int
        }
    }
    
    // Método retornar ao mapa.
    @IBAction func unwindToMap(_ sender: UIStoryboardSegue) {}
    
}
