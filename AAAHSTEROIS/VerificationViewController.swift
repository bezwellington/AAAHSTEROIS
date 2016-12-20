//
//  VerificationViewController.swift
//  AAAHSTEROIS
//
//  Created by Gabriella Lopes on 20/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class VerificationViewController: UIViewController, MPCManagerDelegate {


  @IBOutlet weak var number0: UILabel!
  @IBOutlet weak var number1: UILabel!
  @IBOutlet weak var number2: UILabel!
  @IBOutlet weak var number3: UILabel!
    
    
  //MARK: alterar aqui para a variavel global de codigo
    let code = "5284"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var goingToGVC: Bool!


  
    override func viewDidLoad() {
        super.viewDidLoad()
        goingToGVC = false
      //setCode()
        print("VIEW DID LOAD VERIFICATION VIEW CONTROLLER")
    
        //MARK: descomentar linha abaixo pra desabilitar conexão
        //loadGameVC()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("VIEW WILL APPEAR VVC")
        
        //MARK: comentar linhas abaixo pra desabilitar conexão
        if singlePlayer == false {
            print("ENABLE SERVICES VVC")
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.enableServices(enable: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("VIEW WILL DISAPPEAR VVC")
        print("GOING TO GVC: \(goingToGVC)")
        //condicao para quando a verification view volta para a tela de start match
        if goingToGVC == false {
        appDelegate.mpcManager.session.disconnect()
        }
        
        goingToGVC = false
    }

  func setCode(){
    
    var index = 0
    let codeNumbers = [number0,number1,number2,number3]
    
    for number in 0...3{
    //pega um caractere do string e seta em cada label
      codeNumbers[index]?.text = String(code[code.index(code.startIndex, offsetBy: number)])
      print(code[code.index(code.startIndex, offsetBy: number)])
      index += 1
    }
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func foundPeer(peer: MCPeerID) {
        print("Found Peer!")
    }
    
    func lostPeer() {
        print("Lost Peer!")
        
    }
    
    func invitationWasReceived(fromPeer: String, codeReceived: String?) { }
    
    func connectedWithPeer(peerID: MCPeerID) {
        
        //desativa a busca por peers durante a partida
        appDelegate.mpcManager.browser.stopBrowsingForPeers()
        
        print("\n\n start session with \(peerID.displayName)\n\n")
        goingToGVC = true
        loadGameVC()
    }
  
  //DEPOIS TEM QUE LINKAR COM O HOW TO PLAY
    
    func loadGameVC() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToGameVC", sender: self)
        }
    }
    func handleMessageReceived (messageReceived: Dictionary<String, Any>?){ }
    
    internal func disconnectedWithPeer(peerID: MCPeerID) {
        appDelegate.mpcManager.browser(appDelegate.mpcManager.browser, foundPeer: peerID, withDiscoveryInfo: nil)
    }

}
