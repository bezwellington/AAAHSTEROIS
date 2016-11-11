//
//  GameScene.swift
//  AAAHSTEROIS
//
//  Created by Wellington Bezerra on 07/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let aim = SKSpriteNode(imageNamed: "cross")
    var possibleAsteroidColors:[SKColor] = []
    
    var count = 10
    
    // Persist the initial touch position of the remote
    var touchPositionX: CGFloat = 0.0
    var touchPositionY: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        //satellite.position = CGPoint(x:frame.size.width / 2, y: frame.size.height / 2)
        aim.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        addChild(aim)
        
    
        
        possibleAsteroidColors = [SKColor.red, SKColor.green]
        
        createAsteroidsTimer()
    }
    
    
    func createAsteroidsTimer() {
        
        let asteroidsTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(addRandomAsteroid), userInfo: nil, repeats: true)
        
        asteroidsTimer.fire()
        
        print("created asteroid timer")
    }
    
    func addRandomAsteroid() {
        
        print("add asteroid")
        
        let asteroid = SKSpriteNode(imageNamed: "asteroid2")
        let asteroidFire = SKEmitterNode(fileNamed: "fireParticle")
        
        asteroid.scale(to: CGSize(width: 100, height: 100))
        
        let randomX = CGFloat(arc4random_uniform(UInt32(frame.size.width-asteroid.xScale*1.5)))
        asteroid.position = CGPoint(x:randomX+asteroid.xScale, y: frame.maxY * 1.5)
        addChild(asteroid)
        
        asteroidFire?.targetNode = asteroid
        asteroidFire?.alpha = 0.5
        asteroidFire?.particleColorSequence = nil
        asteroidFire?.particleColorBlendFactor = 1.0
        //aqui dá pra setar a cor que quiser
        asteroidFire?.particleColor = possibleAsteroidColors[Int(arc4random_uniform(UInt32(possibleAsteroidColors.count)))]
        asteroid.addChild(asteroidFire!)
        
        let move = SKAction.moveTo(y: -300, duration: 4)
        let scale = SKAction.scale(to: 0.2, duration: 4)
        let asteroidAnimationGroup = SKAction.group([move,scale])
        

        
        asteroid.run(asteroidAnimationGroup){
            asteroid.removeFromParent()
            print("removed asteroid")
        }

    }
    
    func checksIfAsteroidWasHit(){
        
        //TODO: verificar se o tiro acertou o asteroid
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchPositionX = touch.location(in: self).x
            touchPositionY = touch.location(in: self).y
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if touchPositionX != 0.0 && touchPositionY != 0.0 {
                
                // Calculate the movement on the remote
                let deltaX = touchPositionX - location.x
                let deltaY = touchPositionY - location.y
                
                // Calculate the new Sprite position
                var x = aim.position.x - deltaX
                var y = aim.position.y - deltaY
                
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
                aim.position = CGPoint(x: x, y: y)
                
            }
            // Persist latest touch position
            touchPositionY = location.y
            touchPositionX = location.x
        }
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
