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
    
    //let codeFrame = CGRect(x: 0, y: 0 , width: 400, height: 200)
    
    print("\n \n antes da codeView \n \n")
    
    //codeView = VerificationCodeView(frame: self.view.bounds, verificationCode: "1234")
    //self.view.addSubview(codeView)
    
    //print("\n \n passou pelo codeView \n \n")
    
    
    //appDelegate.mpcManager.delegate = self
    
    //appDelegate.mpcManager.enableServices(enable: true)
    
    loadGameScene()
    
    
  }
  
  func loadGameScene(){
    let skView = view as! SKView
    
    //let scene = SKScene(fileNamed: "GameScene")
    let scene = GameScene(size: view.bounds.size)
    scene.scaleMode = .aspectFill
    skView.ignoresSiblingOrder = true
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.presentScene(scene)
    
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

//extension GameViewController: MPCManagerDelegate {

