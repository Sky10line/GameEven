//
//  GameViewController.swift
//  GameEven
//
//  Created by Rodrigo Ryo Aoki on 26/10/20.
//

import UIKit
import SpriteKit
import GameplayKit

protocol PopViewControllerDelegate {
    func popView()
    func changeLevel(changeTo level: Int)
}

class GameViewController: UIViewController {
    
    var level: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            guard let lvl = level else {
                fatalError("Level nao definido")
            }
            
            changeLevel(changeTo: lvl)
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: PopViewControllerDelegate {
    
    func changeLevel(changeTo level: Int) {
        print("GameViewController ChangeLevel")
        guard let scene = SKScene(fileNamed: "GameScene") else {
            fatalError("Scene nao encontrada")
        }
        guard let s = scene as? GameScene else {
            fatalError("Scene nao e uma GameScene")
        }
        s.viewControllerDelegate = self
        s.level = level
        
        s.scaleMode = .aspectFill
        s.size = UIScreen.main.bounds.size
        //TRANSICAO COM PROBLEMA
//            let transition = SKTransition.fade(withDuration: 1.0)

        guard let view = self.view as? SKView else {
            fatalError("view nao e uma SKView")
        }
        
        view.presentScene(s)
    }
    
    func popView() {
        self.navigationController!.popViewController(animated: true)
    }
}
