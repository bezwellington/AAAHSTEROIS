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
    
    @IBOutlet weak var earthView: EarthView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var codeView: VerificationCodeView!
    var gameScene = GameScene()
    let deadlineTime = DispatchTime.now()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //codeView = VerificationCodeView(frame: self.view.bounds, verificationCode: "1234")
        //self.view.addSubview(codeView)
        
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.enableServices(enable: true)
        
        loadGameScene()
        
        //Função que começa a pegar a aceleração do Remote Control
        startControllerAcceleration()
        
    }
    
    func loadGameScene(){
        let skView = view as! SKView
        
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
        self.gameScene.count += 1
    }
    
}



