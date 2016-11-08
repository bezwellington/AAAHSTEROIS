//
//  GameViewController.swift
//  AAAHSTEROIS
//
//  Created by Wellington Bezerra on 07/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameController

class GameViewController: UIViewController {
    
    var gameScene = GameScene()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as! SKView
        //let scene = SKScene(fileNamed: "GameScene")
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.presentScene(scene)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for item in presses {
            if item.type == .select {
                gameScene.count -= 1
                print("Count = \(gameScene.count)")
            }
        }
        if(gameScene.count == 2){
            print("voce precisa recarregar sua arma")
        }
    }
}
