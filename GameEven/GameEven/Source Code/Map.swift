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
    @IBOutlet var onboardBtn: UIButton!
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var mapLine: UIImageView!
    @IBOutlet weak var comingSoonImage: UIImageView!
    
    
    
    // Variáveis Lógicas
    
    var currentPlayerLevel: Int = 1 // Int com o nível de fases atual do jogador
    
    var scrollFirstTime: Bool = true
    
    var scaleOfObjects: CGFloat = 1
    
    private var audioPlayer = AudioManager.sharedInstance
    
    // MARK: Ciclo de Vida da View
    
    override func viewWillAppear(_ animated: Bool) {
        
        overrideUserInterfaceStyle = .dark
        
        loadingPlayerLevel()
        
        initButtons()
        
        if audioPlayer.musicPlayer?.isPlaying != true || audioPlayer.musicPlayer == nil {
            audioPlayer.playMusic()
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        UIView.appearance().isExclusiveTouch = true
        audioPlayer.musicPlayer?.prepareToPlay()
        audioPlayer.soundPlayer?.prepareToPlay()
        
        //UserDefaults.standard.resetPlayerLevel()
        
        repeatingBackground()
        
        backgroundScrollView.contentOffset.y = 252
        
        buttonWay.forEach { (button) in
            
            let scale = button.frame.height
            
            button.frame = button.frame.resizeWithAspectRatio(extraScale: 1.2)
            
            // Ajusta o texto do botão para aparecer em 1/4 da altura.
            button.titleLabel?.font = button.titleLabel?.font.withSize((button.frame.height/scale)*(button.titleLabel?.font.pointSize)!)
            
            button.titleEdgeInsets = UIEdgeInsets(top: ((button.frame.height) / 4) - ((button.titleLabel?.font.pointSize)! / 4),
                                                  left: 0,
                                                  bottom: 0,
                                                  right: 0)
            
        }
        
        //mapLine.frame = mapLine.frame.resizeWithAspectRatio()
        comingSoonImage.frame = comingSoonImage.frame.resizeWithAspectRatio(extraScale: 1.2)
        
        
        super.viewDidLoad()
        
    }
    
    func disableMultitouchInSubview(of view: UIView) {
       let subviews = view.subviews
       if subviews.count == 0 { return }
       for subview in subviews {
          subview.isExclusiveTouch = true
          disableMultitouchInSubview(of: subview)
       }
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
        
        //scale: UIScreen.main.scale*(image.size.width/(UIScreen.main.bounds.width*UIScreen.main.scale)),
        
        let scaled = UIImage(cgImage: image.cgImage!, scale: UIScreen.main.scale * (image.size.width / (UIScreen.main.bounds.width * UIScreen.main.scale)), orientation: image.imageOrientation)
        
        backgroundScrollView.backgroundColor = UIColor(patternImage: scaled)
        
    }
    
    // Método que baseado no nível de fases do jogador, modifica os botões das fases anteriores e da atual.
    func initButtons() {
        
        buttonWay.forEach { (button) in
            
            if (button.tag <= currentPlayerLevel) {
                
                button.setBackgroundImage(UIImage.init(named: "BlueMapButton"), for: .normal)
                button.addTarget(self, action: #selector(enterInInstruction), for: .touchUpInside)
            } else  {
                button.setBackgroundImage(UIImage.init(named: "GrayMapButton"), for: .normal)
                button.removeTarget(nil, action: nil, for: .allEvents)
            }
        }
        onboardBtn.addTarget(self, action: #selector(goToOnboard), for: .touchUpInside)
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
            animateScroll(position: 0.0)
        }
    }
    
    // Método que anima a movimentação do scroll até chegar ao nível atual.
    func animateScroll(position: CGFloat) {
        UIView.animate(withDuration: 1.00, delay: 0.10, animations: {
            self.backgroundScrollView.contentOffset.y = position
        })
        
        
        
    }
    
    //MARK: Entrada e Saída da View
    @objc func goToOnboard(sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Onboard") as! OnboardViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
        audioPlayer.playSound(SoundType: .button)
    }
    // Método para o jogador entrar na fase referente a .tag do botão.
    @objc func enterInInstruction(sender: UIButton!) {
        audioPlayer.playSound(SoundType: .button)
        performSegue(withIdentifier: "goToInstruction", sender: sender.tag)
    }
    
    // Função que passará a fase selecionada e chamará a próxima tela.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToInstruction") {
            guard let instructionView = segue.destination as? GameViewController else { return }
            
            instructionView.level = sender as? Int
        }
    }
    @IBAction func ConfigSoundBtn(_ sender: Any) {
        audioPlayer.playSound(SoundType: .button)
    }
    
    // Método retornar ao mapa.
    @IBAction func unwindToMap(_ sender: Any) {
        //let storyboard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "Onboard") as! OnboardViewController
        //self.show(vc, sender: self)
    }
}

extension CGRect {
    
    func resizeWithAspectRatio (extraScale: CGFloat) -> CGRect {
        
        let scaleInWidth = CGFloat(UIScreen.main.bounds.maxX / 414)
        let scaleInHeight = CGFloat(UIScreen.main.bounds.maxY / 896)
        
        if ((scaleInWidth < 1 || scaleInHeight < 1) && UIScreen.main.nativeScale != 3) {
            
            let realScale = min(scaleInWidth,scaleInHeight)
            
            let realWidth = (width * realScale) * extraScale
            let realHeight = (height * realScale) * extraScale
            
            let realPosX = minX + (width - realWidth) / 2
            let realPosY = minY + (height - realHeight) / 2
            
            return CGRect.init(x: realPosX, y: realPosY, width: realWidth, height: realHeight)
        }
        
        return CGRect.init(x: minX, y: minY, width: width, height: height)
    }
}
