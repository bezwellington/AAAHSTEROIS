//
//  GameViewControllerExtension.swift
//  AAAHSTEROIS
//
//  Created by Gabrielle Brandenburg dos Anjos on 08/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit
import MultipeerConnectivity

enum MessageType: Int {
    case MOVE = 1, SHOOT, RECHARGE
}

extension GameViewController: MPCManagerDelegate {
    
    func foundPeer(peer: MCPeerID) {
        print("Found Peer!")
        
    }
    
    func lostPeer() {
        print("Lost Peer!")
        appDelegate.mpcManager.enableServices(enable: true)
    }
    
    //não é usado na apple tv
    func invitationWasReceived(fromPeer: String, codeReceived: String?) {
        //var textField: UITextField?
        
        //criação de um alert view em que o usuario digita o código que aparece na Apple TV para fazer a conexão
        let alert = UIAlertController(title: "Join a match", message: "Enter the code shown on your Apple TV", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: textFieldHandler)
        
        let codeTyped = alert.textFields?.first?.text
        
        alert.addAction(UIAlertAction(title: "Connect", style: UIAlertActionStyle.default, handler:{ (UIAlertAction) in
            
            if codeReceived != nil {
                if codeTyped == codeReceived {
                    self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
                    print("Started session with \(fromPeer)")
                        self.appDelegate.mpcManager.enableServices(enable: false)
                }
                else {
                    //TODO: implementar um erro decente para código errado
                    print("ERROR! Wrong code typed. Couldn't start session with \(fromPeer)")
                    
                    self.appDelegate.mpcManager.invitationHandler(false, nil)
                }
            }
            
        }))
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldHandler(textField: UITextField!)
    {
        if (textField) != nil {
            textField.placeholder = "code"
        }
    }
    
    //quando a conexão é estabelecida, a tela muda para a gamescene
    
    func connectedWithPeer(peerID: MCPeerID) {
        //TODO: tratar a queda de conexão durante o jogo e a volta da conexão
        //se a conexão cai durante o jogo, não é necessário dar load na gameScene novamente
        print("CONNECTED WITH PEER")
        game3DView.scene?.isPaused = false
        game3DView.overlaySKScene?.scene?.isPaused = false
    }
    
    func disconnectedWithPeer(peerID: MCPeerID) {
        print("DISCONNECTED WITH PEER")
        print(" OVERLAY VIEW::::::::::: \(game3DView)")
        //game3DView.becomeFirstResponder()
        game3DView.scene?.isPaused = true
        game3DView.overlaySKScene?.scene?.isPaused = true
        appDelegate.mpcManager.enableServices(enable: true)
    }
    
    func handleMessageReceived (messageReceived: Dictionary<String, Any>?){
        
        let rawValue = messageReceived?["message"] as? Int
        
        let messageType = MessageType(rawValue: rawValue!)
        
        print("\n MESSAGE TYPE : \(messageType) \n")
        let peerName = messageReceived?["sender"] as? String
        
        
        switch messageType! {
        case .SHOOT:
             print("\n SHOOT RECEIVED FROM \(peerName)")
            
            //TODO: chamar aqui a função que atira no asteroide com o player 2
             if overlay.searchAndDestroyAsteroid(name: peerName!) {
                
                DispatchQueue.main.async {
                    self.increaseScore()
                }
            }
        case .MOVE:
            
            let dx = messageReceived?["dx"] as? Double
            let dy = messageReceived?["dy"] as? Double

            let vector = CGVector(dx: dx!, dy: dy!)
            print("\n MOVE RECEIVED FROM \(peerName) direction: \(dx,dy)")
            
            //TODO: chamar aqui a função que move a mira do player 2
            overlay.searchAndMovePlayer(name: peerName!, direction: vector)
        case .RECHARGE:
            overlay.searchAndRecharge(name: peerName!)
            break
        }
        
    }
}
