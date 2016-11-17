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

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var aimClass = AimClass()
    var game3DView: Game3DView!
  var count = 8
  // Persist the initial touch position of the remote
  var touchPositionX: CGFloat = 0.0
  var touchPositionY: CGFloat = 0.0
  
  
    override func didMove(to view: SKView) {
        addAim()
    }
    
    func getViewPosition(pos : CGPoint) -> CGPoint{
        return CGPoint(x:pos.x,y:1080-pos.y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            game3DView = self.game3DView as SCNView as! Game3DView
            let touchLocation = touch.location(in: game3DView)
            print(touchLocation)
            touchPositionX = touchLocation.x
            touchPositionY = touchLocation.y
            
            print(aimClass.aim.position)
            var pos = getViewPosition(pos: aimClass.aim.position)
            //pos = game3DView.convert(pos, from: self.view!)
            //var convert3DGame = game3DView.convert(pos, from: self.scene!.view)
            //print(convert3DGame)
            let hitResuts = game3DView.hitTest(pos, options: nil)
            print(hitResuts.count)
            for t in hitResuts{
                if t.node.name == "button" {
                    print("encostei, viadao")
                }
            }
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
                var x = aimClass.aim.position.x - deltaX
                var y = aimClass.aim.position.y - deltaY
                
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
    
    
}
