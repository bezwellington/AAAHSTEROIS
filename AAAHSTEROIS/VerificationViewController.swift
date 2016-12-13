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
  
  let code = "1234"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


  
    override func viewDidLoad() {
        super.viewDidLoad()

      //setCode()
        print("VIEW DID LOAD VERIFICATION VIEW CONTROLLER")
        //MARK: comentar linhas abaixo pra desabilitar conexão
        
        //appDelegate.mpcManager.enableServices(enable: true)
        
        //MARK: descomentar linha abaixo pra desabilitar conexão
        //loadGameVC()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("VIEW WILL APPEAR VVC")
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.enableServices(enable: true)
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
        
        loadGameVC()
    }
    
    func loadGameVC() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToGameVC", sender: self)
        }
    }
    func handleMessageReceived (messageReceived: Dictionary<String, Any>?){ }
    
    internal func disconnectedWithPeer(peerID: MCPeerID) { }

}
