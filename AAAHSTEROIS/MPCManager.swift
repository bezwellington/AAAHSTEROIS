//
//  MPCManager.swift
//  AAAHSTEROIS
//
//  Created by Gabrielle Brandenburg dos Anjos on 08/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol MPCManagerDelegate {
    func foundPeer(peer: MCPeerID)
    
    func lostPeer()
    
    func invitationWasReceived(fromPeer: String, codeReceived: String?)
    
    func connectedWithPeer(peerID: MCPeerID)
    
    func handleMessageReceived (messageReceived: Dictionary<String, Any>?)
}

class MPCManager: NSObject {
    let peerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
    let serviceType = "aaahsteroids"
    
    var browser: MCNearbyServiceBrowser
    var advertiser: MCNearbyServiceAdvertiser
    
    var delegate: MPCManagerDelegate?
    
    var foundPeers = [MCPeerID]()
    
    var invitationHandler: ((Bool, MCSession?) -> Void)!
    
    lazy var session:MCSession = {
        let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        return session
    }()

    override init () {
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        
        self.browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        
        super.init()
        
        self.advertiser.delegate = self
        self.browser.delegate = self
        self.session.delegate = self
        
    }
    
    func enableServices(enable: Bool) -> Void {
        if(enable){
            //advertiser.startAdvertisingPeer()
            print("\n\n start browsing for peers \n\n")
            browser.startBrowsingForPeers()
        } else {
            //advertiser.stopAdvertisingPeer()
            browser.stopBrowsingForPeers()
        }
    }
    
    func sendData(dictionaryData: [String:String], toPeer: MCPeerID) -> Bool{
        
        let dataToSend: Data = NSKeyedArchiver.archivedData(withRootObject: dictionaryData)
        let peerArray: [MCPeerID] = [toPeer]
        
        if session.connectedPeers.count > 0 {
            do{
                try
                    self.session.send(dataToSend, toPeers: peerArray, with: MCSessionSendDataMode.reliable)
                return true
            } catch {
                print("error sending data to \(toPeer)")
                return false
            }
        }
        print("no peer connected")
        return false
    }
    
    
}

// acho que a advertiser não será usada na AppleTV por enquanto
extension MPCManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        //por enquanto vai aceitar automaticamente o convite
        //TODO: validação do código da appleTV
        
        var strContext: String?
        
        self.invitationHandler = invitationHandler
        
        if let ctx = context {
            strContext = String(data: ctx, encoding: String.Encoding.utf8)
            print("string code: \(strContext)")
        } else {
            print("no code received")
        }
        
        delegate?.invitationWasReceived(fromPeer: peerID.displayName, codeReceived: strContext)
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }
    
}

extension MPCManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        foundPeers.append(peerID)
        
        print("\n \n ACHOU UM PEER \(peerID.displayName) \n\n")
        
        //TODO: Criar um código numerico aleatório de 4 algarismos
        let codeData = "1234".data(using: String.Encoding.utf8)
        
        browser.invitePeer(peerID, to: session, withContext: codeData, timeout: 60)
        print("\n\n CONVIDOU O PEER \n\n")
        
        delegate?.foundPeer(peer: peerID)
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in foundPeers.enumerated(){
            if aPeer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
        
        
        print("PERDEU O PEER")
        delegate?.lostPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error.localizedDescription)
    }
}

extension MPCManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case .connected:
            print("\n \n Connected to session: \(session)\n\n")
            delegate?.connectedWithPeer(peerID: peerID)
        case .connecting:
            print("\n\nConnecting to session: \(session)\n\n")
        default:
            print("\n\nDid not connect to session: \(session)\n\n")
            self.delegate?.lostPeer()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        let dictionaryReceived: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any]
        
        delegate?.handleMessageReceived(messageReceived: dictionaryReceived)
    }
    
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
        print("\n\n DID START RECEIVING RESOURCE FROM IPHONE \n\n")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    
}
