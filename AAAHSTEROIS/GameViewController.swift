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
  
  
  @IBOutlet weak var game3DView: Game3DView!
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var codeView: VerificationCodeView!
  let deadlineTime = DispatchTime.now()
  var overlay = GameScene()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //codeView = VerificationCodeView(frame: self.view.bounds, verificationCode: "1234")
    //self.view.addSubview(codeView)
    
    appDelegate.mpcManager.delegate = self
    appDelegate.mpcManager.enableServices(enable: true)
    
    game3DView.loadGame()
    game3DView.showsStatistics = true
    
    overlay = GameScene(size: self.view.bounds.size)
    
    game3DView.overlaySKScene = overlay

    //Função que começa a pegar a aceleração do Remote Control
    startControllerAcceleration()
    
  }


  
//  func loadGameScene(){
//    
//    game3DView.loadGame()
//    game3DView.showsStatistics = true
//    
//    let overlay = GameScene(size: self.view.bounds.size)
//    // Sobrepõe o conteúdo 2D do SpriteKit
//    game3DView.overlaySKScene = overlay
//    
//    
//  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
    
    for item in presses {
      //Se o TrackPad for pressionado
      if item.type == .select {
        if overlay.count > 0{
        overlay.count -= 1
          
        //TODO: MANDAR COR REAL DA MIRA
        overlay.aimClass.changeColor(color: "verde", number: overlay.count)
        print("Count = \(overlay.count)")
        }
      }
    }
    // Se o número de munição for 0
    if(overlay.count == 0){
      //TODO: BOTAR "RELOAD" ESCRITO PISCANDO NA MIRA
      print("voce precisa recarregar sua arma")
    }
  }
  
  func startControllerAcceleration() {
    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
      self.atualiza()
    })
  }
  
  func atualiza() {
    GCController.controllers().first?.motion?.valueChangedHandler = { motion in
      let realAcceleration = motion.userAcceleration
      if (realAcceleration.x > 5 || realAcceleration.y > 5 || realAcceleration.z > 5)
      {
        print("Arma recarregada com sucesso!")
        //print ("Aceleração real! \(realAcceleration)")
        //print ("Aceleração x! \(realAcceleration.x)")
        //print ("Aceleração y! \(realAcceleration.y)")
        //print ("Aceleração z! \(realAcceleration.z)")
        self.reloadWeapon()
      }
    }
    
  }
  
  // Função que recarrega arma
  func reloadWeapon(){
    self.overlay.count += 1
  }
  
  
}



