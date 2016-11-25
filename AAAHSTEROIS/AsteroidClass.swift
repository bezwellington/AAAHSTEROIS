//
//  Asteroids.swift
//  AAAHSTEROIS
//
//  Created by Wellington Bezerra on 13/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import Foundation
import SceneKit
import UIKit

class AsteroidClass {
    
    let asteroidCategory: Int = 1
    let asteroidNode = SCNNode()
    let asteroidGeometry = SCNSphere(radius: 0.2)
    
    init(colors:[UIColor]){
        
        asteroidNode.geometry = asteroidGeometry
        asteroidNode.name = "asteroid"
        asteroidNode.physicsBody = SCNPhysicsBody.kinematic()
        asteroidNode.position = randomizePosition()
        asteroidNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "asteroidMaterial1")
        
        let asteroidFire = SCNParticleSystem(named: "fire.scnp", inDirectory: nil)!
        
        asteroidFire.particleColor = randomizeColor(colors: colors)
        asteroidNode.addParticleSystem(asteroidFire)
    }
    
    func randomizeColor(colors:[UIColor]) -> UIColor{
        
        let randomColor = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randomColor]
    }
    
    func randomizePosition() -> SCNVector3{
        
        let randomX = Float(arc4random_uniform(10))
        return SCNVector3Make(randomX-5, 4,-20)
    }
    
    func animateAsteroid(){
        
        let asteroidFallDuration = Float(arc4random_uniform(6)) + 4.5
        
        asteroidNode.runAction(SCNAction.move(to: SCNVector3Make(asteroidNode.position.x, -5, -20), duration: TimeInterval(asteroidFallDuration))){
            
            self.asteroidNode.removeFromParentNode()
            //print("removed 3d asteroid")
        }
    }
    
    
}
