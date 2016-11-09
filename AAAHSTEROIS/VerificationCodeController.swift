//
//  VerificationCodeController.swift
//  AAAHSTEROIS
//
//  Created by Gabrielle Brandenburg dos Anjos on 08/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class VerificationCodeController:UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var codeView: VerificationCodeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n \n antes da codeView \n \n")
        
        codeView = VerificationCodeView(frame: self.view.bounds, verificationCode: "1234")
        self.view.addSubview(codeView)
        
        print("\n \n passou pelo codeView \n \n")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/*extension GameViewController: MPCManagerDelegate {

    func foundPeer() {
        print("Found Peer!")
    }
    
    func lostPeer() {
        print("Lost Peer!")
    }
    
    func invitationWasReceived(fromPeer: String, codeReceived: String?) {
    }
    
    //conexao com o iphone é estabelecida
    func connectedWithPeer(peerID: MCPeerID) {
        
    }
}*/
