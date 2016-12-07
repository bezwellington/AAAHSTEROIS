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
    let deadlineTime = DispatchTime.now()
    var overlay = GameScene()
    var numberOfAcceleration = 0
    var energyAim = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n VIEW DID LOAD GAME VC \n")
        appDelegate.mpcManager.delegate = self
        loadGameScene()
        
        let observerOptions = NSKeyValueObservingOptions([.new, .old, .initial, .prior])
        game3DView.addObserver(self, forKeyPath: "gameOver", options: observerOptions, context: nil)
    }
    
    func loadGameScene(){
        
        game3DView.loadGame()
        game3DView.showsStatistics = true
        
        overlay = GameScene(size: self.view.bounds.size)
        
        // Sobrepõe o conteúdo 2D do SpriteKit
        game3DView.overlaySKScene = overlay
        overlay.game3DView = game3DView
        
        //Função que começa a pegar a aceleração do Remote Control
        startControllerAcceleration()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        for item in presses {
            //Se o TrackPad for pressionado
            if item.type == .playPause{
                if self.energyAim > 0{
                    self.energyAim -= 1
                    
                    overlay.runHitTest()
                    //TODO: TROCA A COR DA MIRA
                    overlay.aimClass.changeColor(color: "verde", number: self.energyAim)
                }
            }
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
            if (realAcceleration.x > 2 || realAcceleration.y > 2 || realAcceleration.z > 2)
            {
                // Variável que conta o número de aceleração por Shake
                self.numberOfAcceleration += 1
                self.checkNumberOfAcceleration(numberOfAcceleration: self.numberOfAcceleration)
            }
            
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "gameOver"{
            if let newValue = change?[NSKeyValueChangeKey.newKey] as? Int{
                if newValue == 1{
                    print("___***___ VC DETECTOU GAME OVER")
                    gameOver()
                }
            }
        }
    }
    
    func gameOver() {
        
        performSegue(withIdentifier: "goToGameOverVC", sender: self)
    }
    
    // Função que verifica a qtd de aceleração por Shake
    func checkNumberOfAcceleration(numberOfAcceleration: Int){
    
        if self.numberOfAcceleration >= 5{
            print("Arma recarregada com sucesso!")
            self.reloadWeapon()
            self.numberOfAcceleration = 0
        }
    
    }
    
    // Função que recarrega arma
    func reloadWeapon(){
        self.energyAim = 8
        overlay.aimClass.changeColor(color: "verde", number: self.energyAim)
    }
    
}



