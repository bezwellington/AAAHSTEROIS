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
    
    let satellite = SKSpriteNode(imageNamed: "cross")
    var asteroid = SKSpriteNode(imageNamed: "asteroid")
    let asteroidFire = SKEmitterNode(fileNamed: "fireParticle")
    
    // Persist the initial touch position of the remote
    var touchPositionX: CGFloat = 0.0
    var touchPositionY: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        //satellite.position = CGPoint(x:frame.size.width / 2, y: frame.size.height / 2)
        satellite.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        addChild(satellite)
      
        asteroid.scale(to: CGSize(width: 100, height: 100))
        asteroid.position = CGPoint(x:frame.size.width / 2, y: frame.maxY * 1.5)
        addChild(asteroid)
      
        asteroidFire?.targetNode = asteroid
        asteroidFire?.alpha = 0.5
        asteroid.addChild(asteroidFire!)
      

        
        backgroundColor = UIColor.black
      
        moveAsteroid()
    }
  

  func moveAsteroid(){
    
    print("move asteroid")
    asteroid.run(SKAction.moveTo(y: self.frame.minY, duration: 3))
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
                var x = satellite.position.x - deltaX
                var y = satellite.position.y - deltaY
                
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
                satellite.position = CGPoint(x: x, y: y)
              
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
