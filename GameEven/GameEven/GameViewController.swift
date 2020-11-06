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
    func changeLevel()
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load")
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size = UIScreen.main.bounds.size
                // Present the scene
                if let s = scene as? GameScene {
                    s.viewControllerDelegate = self
                }
                view.presentScene(scene)
            }
            
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
    
    func changeLevel() {
        print("GameViewController ChangeLevel")
        guard let scene = SKScene(fileNamed: "GameScene") else {
            fatalError("Scene nao encontrada")
        }
        guard let s = scene as? GameScene else {
            fatalError("Scene nao e uma GameScene")
        }
        s.viewControllerDelegate = self
        s.level = 1
        // Set the scale mode to scale to fit the window
        s.scaleMode = .aspectFill
        s.size = UIScreen.main.bounds.size
        //TRANSICAO COM PROBLEMA
//            let transition = SKTransition.fade(withDuration: 1.0)
        // Present the scene
        guard let view = self.view as? SKView else {
            fatalError("view nao e uma SKView")
        }
        view.presentScene(s)
    }
    
    func popView() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
}
