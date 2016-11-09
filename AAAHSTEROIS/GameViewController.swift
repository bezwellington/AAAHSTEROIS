//
//  GameViewController.swift
//  AAAHSTEROIS
//
//  Created by Wellington Bezerra on 07/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit
import GameplayKit
import GameController

class GameViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
     var codeView: VerificationCodeView!
    var gameScene = GameScene()
    

  @IBOutlet weak var earthView: EarthView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    //codeView = VerificationCodeView(frame: self.view.bounds, verificationCode: "1234")
    //self.view.addSubview(codeView)
    
    appDelegate.mpcManager.delegate = self
    appDelegate.mpcManager.enableServices(enable: true)
    
    
    loadGameScene()
  }
  
  func loadGameScene(){
    let skView = view as! SKView
    
    //let scene = SKScene(fileNamed: "GameScene")
    gameScene.size = view.bounds.size
    gameScene.scaleMode = .aspectFill
    skView.ignoresSiblingOrder = true
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.presentScene(gameScene)
    
    earthView.load3DEarth()
    
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



