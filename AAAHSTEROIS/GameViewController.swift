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
            if item.type == .select {
                if overlay.count > 0{
                    overlay.count -= 1
                    overlay.runHitTest()
                    //TODO: MANDAR COR REAL DA MIRA
                    overlay.aimClass.changeColor(color: "verde", number: overlay.count)
                    print("Count = \(overlay.count)")
                }
            }
        }
        // Se o número de munição for 0
        if(overlay.count == 0){
            //TODO: BOTAR "RELOAD" ESCRITO PISCANDO NA MIRA
            overlay.aimClass.changeColor(color: "verde", number: 0)
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
    
    // Função que recarrega arma
    func reloadWeapon(){
        self.overlay.count += 1
    }
    
}



