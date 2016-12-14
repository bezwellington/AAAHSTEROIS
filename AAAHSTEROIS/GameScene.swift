    //
    //  GameScene.swift
    //  AAAHSTEROIS
    //
    //  Created by Wellington Bezerra on 07/11/16.
    //  Copyright © 2016 Wellington Bezerra. All rights reserved.
    //
    
    import SpriteKit
    import GameplayKit
    import SceneKit
    import MultipeerConnectivity
    
    class GameScene: SKScene, SKPhysicsContactDelegate {
        
        var laserFireSound = SKAction.playSoundFileNamed("laserFire6.wav", waitForCompletion: false)
        var gamePlaySound = SKAction.playSoundFileNamed("gameplay4.wav", waitForCompletion: true)
        var laserRechargeSound = SKAction.playSoundFileNamed("laserRecharge2.wav", waitForCompletion: false)
        var collisionSound = SKAction.playSoundFileNamed("asteroidEarthExplosion.wav", waitForCompletion: false)
        
        
        //referencia ao delegate pra poder acessa o MPCManager
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var aimClass = AimClass()
        var game3DView: Game3DView!
        
        var iphonePlayer = [IphonePlayer]()
        
        
        
        // Persist the initial touch position of the remote
        var touchPositionX: CGFloat = 0.0
        var touchPositionY: CGFloat = 0.0
        
        override func didMove(to view: SKView) {
            
            setupBorder()
            addAim()
            
            
            //MARK: comentar linha abaixo pra desabilitar conexão
            print("SINGLE PLAYER ----- \(singlePlayer)")
            if singlePlayer == false {
                iphonePlayer = setupIphonePlayers() }
        }
        
        func setupBorder(){
            let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
            borderBody.friction = 0
            borderBody.linearDamping = 0.0
            self.physicsBody = borderBody
            
        }
        
        func getViewPosition(pos : CGPoint) -> CGPoint{
            return CGPoint(x:pos.x,y:1080-pos.y)
        }
        
        func setupIphonePlayers() -> [IphonePlayer] {
            
            //coordenada da mira inicialmente no centro pra todos os players, futuramente pode ser mudado para um cálculo de coordenada que leva em conta a quantidade de players conectados
            
            print("\n will start setup players \n")
            let coordinate = CGPoint(x:self.frame.midX, y:self.frame.midY)
            var color = String()
            var name = String()
            
            let peers = appDelegate.mpcManager.session.connectedPeers
            var players = [IphonePlayer]()
            
            let aimColors = ["verde", "vermelha", "azul", "amarela"]
            
            //configura cada um dos players conectados e adiciona no array de players
            print("\n\n PEER COUNT: \(peers.count) \nPEER FOUND: \(peers[0].displayName)")
            for i in 0...(peers.count - 1)  {
                color = aimColors[i]
                name = peers[i].displayName
                print("setup player \(name)")
                let player = IphonePlayer(coordinate: coordinate, color: color, name: name, number: i)
                self.addChild(player.laser)
                
                players.append(player)
            }
            
            return players
        }
        
        //chamada quando recebe uma mensagem do iphone para mover a mira
        func searchAndMovePlayer (name: String, direction: CGVector){
            var dir = direction
            //busca o nome do jogador linearmente e quando achar move a mira na direção recebida
            for i in 0...(iphonePlayer.count - 1) {
                if iphonePlayer[i].name == name {
                    print("\n SEARCH AND MOVE - FOUND PLAYER")
                    dir.applyModule(speed: iphonePlayer[i].speed)
                    iphonePlayer[i].move(direction: dir)
                    break
                }
            }
        }
        
        func searchAndDestroyAsteroid(name: String) -> Bool{
            
            for i in 0...(iphonePlayer.count - 1) {
                if iphonePlayer[i].name == name {
                    
                    iphonePlayer[i].shoot()
                    
                    //MARK: descomentar quando existir a classe do asteroide e for possível checar o color matching
                    var pos = iphonePlayer[i].laser.position
                    pos = getViewPosition(pos: pos)
                    let hitResuts = game3DView.hitTest(pos, options: nil)
                    print(hitResuts.count)
                    for t in hitResuts{
                        if t.node.name == "asteroid" {
                            
                            //TODO: CHECAR O COLOR MATCHING
                            print("encostei, viadao IPHONE")
                            if let nodeColor = t.node.particleSystems?.first?.particleColor {
                                print("_____________ NODE COLOR \(nodeColor)")
                                if nodeColor == UIColor.cyan {
                                    t.node.removeFromParentNode()
                                }
                                
                                return true
                            }
                        }
                    }
                    return false
                }
            }
            return false
        }
        
        //chamada quando recebe mensagem do controller para recarregar laser
        func searchAndRecharge(name: String) {
            for i in 0...(iphonePlayer.count - 1) {
                if iphonePlayer[i].name == name {
                    
                    iphonePlayer[i].recharge()
                }
            }
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                
                game3DView = self.game3DView as SCNView as! Game3DView
                let touchLocation = touch.location(in: game3DView)
                print(touchLocation)
                touchPositionX = touchLocation.x
                touchPositionY = touchLocation.y
            }
        }
        
        func runHitTest() -> Bool{
            let pos = getViewPosition(pos: aimClass.aim.position)
            let hitResuts = game3DView.hitTest(pos, options: nil)
            print(hitResuts.count)
            for t in hitResuts{
                if t.node.name == "asteroid" {
                    print("encostei, viadao")
                    if let nodeColor = t.node.particleSystems?.first?.particleColor {
                        print("_____________ NODE COLOR \(nodeColor)")
                        if nodeColor == UIColor.yellow {
                            t.node.removeFromParentNode()
                        }
                        
                        return true
                    }
                }
            }
            return false
            
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                
                if touchPositionX != 0.0 && touchPositionY != 0.0 {
                    
                    // Calculate the movement on the remote
                    let deltaX = touchPositionX - location.x
                    let deltaY = touchPositionY - location.y
                    
                    // Calculate the new Sprite position
                    
                    // Control Remote in the vertical
                    //var x = aimClass.aim.position.x - deltaX
                    //var y = aimClass.aim.position.y - deltaY
                    
                    // Control Remote in the horizontal
                    var x = aimClass.aim.position.x + deltaY
                    var y = aimClass.aim.position.y - deltaX
                    
                    // Check if the sprite will leave the screen
                    if x < 0 {
                        x = 0
                    } else if x > self.frame.width {
                        x = self.frame.width
                    }
                    if y < 0 {
                        y = 0
                    } else if y > self.frame.height {
                        y = self.frame.height
                    }
                    
                    // Move the sprite
                    aimClass.aim.position = CGPoint(x: x, y: y)
                }
                // Persist latest touch position
                touchPositionY = location.y
                touchPositionX = location.x
            }
            
        }
        
        override func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
        }
        
        func addAim() {
            aimClass.aim.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
            
            addChild(aimClass.aim)
        }
        
        func runAction(action: SKAction){
            run(action)
        }
        
        
    }
    
