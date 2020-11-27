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
    
    var level: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.view as? SKView) != nil {
            // Load the SKScene from 'GameScene.sks'
//            guard let lvl = level else {
//                fatalError("Level nao definido")
//            }
            
            changeLevel(changeTo: level)
            
//            debugging(view: view)
        }
    }
    
    func debugging(view: SKView){
        view.ignoresSiblingOrder = true
        view.showsPhysics = true
        view.showsFPS = true
        view.showsNodeCount = true
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
            let transition = SKTransition.fade(withDuration: 1.0)

        guard let view = self.view as? SKView else {
            fatalError("view nao e uma SKView")
        }
        if let oldScene = view.scene as? GameScene {
            oldScene.viewControllerDelegate = nil
        }
        
        
        view.presentScene(s, transition: transition)
    }
    
    func popView() {
        if let view = self.view as! SKView? {
            guard let scene = view.scene as? GameScene else {
                fatalError("Problema de....")
            }
            scene.viewControllerDelegate = nil
        }
        self.navigationController!.popViewController(animated: true)
    }
}
