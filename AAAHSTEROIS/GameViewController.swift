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
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lostConnectionView: UIStackView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let deadlineTime = DispatchTime.now()
    var overlay = GameScene()
    var numberOfAcceleration = 0
    var energyAim = 8
    var currentScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n VIEW DID LOAD GAME VC \n")
    }
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.mpcManager.delegate = self
        loadGameScene()
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("VIEW WILL DISAPPEAR GVC")
        appDelegate.mpcManager.session.disconnect()
    }
    
    func loadGameScene(){
        game3DView.loadGame()
        game3DView.showsStatistics = false
        
        overlay = GameScene(size: self.view.bounds.size)
        
        // Sobrepõe o conteúdo 2D do SpriteKit
        game3DView.overlaySKScene = overlay
        overlay.game3DView = game3DView
        
        //Função que começa a pegar a aceleração do Remote Control
        startControllerAcceleration()
        
        // Som do início do jogo
        overlay.run(SKAction.repeatForever(overlay.gamePlaySound))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func increaseScore() {
        print("___increase score")
        self.currentScore += 1
        self.scoreLabel.text = String(self.currentScore)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        for item in presses {
            //Se o TrackPad for pressionado
            if item.type == .playPause{
                // Som do tiro do laser
                
                overlay.runAction(action: overlay.laserFireSound)
                if self.energyAim > 0{
                    self.energyAim -= 1
                    
                    if overlay.runHitTest() {
                        print("hitTest retornou true pra VC")
                        increaseScore()
                    }
                    //TODO: TROCA A COR DA MIRA
                    overlay.aimClass.changeColor(color: "vermelha", number: self.energyAim)
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
    
    func gameOver() {
        
        
        performSegue(withIdentifier: "goToGameOverVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToGameOverVC"{
            
            if let nextVC = segue.destination as? GameOverViewController {
                nextVC.finalScoreNumber = self.currentScore
            }
        }
        
    }
    
    // Função que verifica a qtd de aceleração por Shake
    func checkNumberOfAcceleration(numberOfAcceleration: Int){
    
        if self.numberOfAcceleration >= 5{
            print("Arma recarregada com sucesso!")
            // Recarga da energia da mira
            overlay.runAction(action: overlay.laserRechargeSound)
            self.reloadWeapon()
            self.numberOfAcceleration = 0
        }
    
    }
    
    // Função que recarrega arma
    func reloadWeapon(){
        self.energyAim = 8
        overlay.aimClass.changeColor(color: "vermelha", number: self.energyAim)
    }
    
}



