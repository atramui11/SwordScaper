//
//  GameViewController.swift
//  SwordScape


import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		let scene = FightScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
		let view = self.view as! SKView
		view.showsFPS = false
		view.showsNodeCount = false
		view.ignoresSiblingOrder = false
		scene.scaleMode = .aspectFill
		view.presentScene(scene)
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
