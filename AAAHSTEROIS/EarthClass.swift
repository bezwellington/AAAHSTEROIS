//
//  EarthClass.swift
//  AAAHSTEROIS
//
//  Created by Wellington Bezerra on 13/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import Foundation
import SceneKit
import UIKit

class EarthClass {
    
    let earthGeometry = SCNSphere(radius: 12)
    let earthNode = SCNNode()
    let earthCategory: Int = 2
    var hitCount = 0
    
    init(){
        
        earthGeometry.segmentCount = 80
        
        earthNode.geometry = earthGeometry
        earthNode.position = SCNVector3Make(0, -14, -20)
        earthNode.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "specularMap")
        earthNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "terra0")
        earthNode.name = "earth"
        earthNode.physicsBody = SCNPhysicsBody.kinematic()
        earthNode.physicsBody?.categoryBitMask = earthCategory
        rotate()
        
        //CLOUDS
        
        //    let cloudGeometry = SCNSphere(radius:13) //730
        //    cloudGeometry.segmentCount = 80 //250
        //
        //    cloudGeometry.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "cloudMap")
        //    cloudGeometry.firstMaterial?.transparent.contents = #imageLiteral(resourceName: "cloudTransparencyMap")
        //
        //    let cloudNode = SCNNode(geometry: cloudGeometry)
        //    earthNode.addChildNode(cloudNode)
    }
    
    func rotate(){
        
        earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 1, y: 1, z: 1, duration: 70)))
    }
    
    func wasHit() -> Bool{
        
        if self.hitCount < 10 {
        self.hitCount += 1
        self.earthNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "terra\(hitCount)")
        return false
        } else if self.hitCount == 10{
            print("GAME OVER")
            self.hitCount += 1
            //MARK: Para desativar game over, comentar linha abaixo
            return true
            
        }
        return false
    }
    
    
}
