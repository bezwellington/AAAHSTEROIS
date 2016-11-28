//
//  EarthView.swift
//  AAAHSTEROIS
//
//  Created by Gabriella Lopes on 08/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit
import SceneKit

class Game3DView: SCNView, SCNPhysicsContactDelegate, SCNSceneRendererDelegate {
    
    let possibleAsteroidColor:[UIColor] = [UIColor.cyan, UIColor.yellow]
    let earth = EarthClass()
    let earthCategory: Int = 2
    
    var asteroidFrequency = 3.0
    var currentAsteroidRound = 0
    var asteroidsTimer = Timer()
    
    
    func loadGame(){
        self.delegate = self
        sceneSetup()
        earthSetup()
        createAsteroids()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        print(scene?.rootNode.childNodes.count)
    }
    
    func createAsteroids() {
        
        if asteroidsTimer.isValid {
            
            asteroidsTimer.invalidate()
        }
        
        asteroidsTimer = Timer()
        
        self.asteroidsTimer = Timer.scheduledTimer(timeInterval: self.asteroidFrequency, target: self, selector: #selector(addAsteroid), userInfo: nil, repeats: true)
        
        asteroidsTimer.fire()
        //print("created 3d asteroid timer")
    }

    
    func addAsteroid(){
        
        let asteroid = AsteroidClass(colors: possibleAsteroidColor)
        asteroid.asteroidNode.physicsBody?.contactTestBitMask = earthCategory
        
        self.scene?.rootNode.addChildNode(asteroid.asteroidNode)
        asteroid.animateAsteroid()
        
        manageAsteroidRound()
    }
    
    func manageAsteroidRound(){
        
        self.currentAsteroidRound += 1
        
        if self.currentAsteroidRound == 10{
            if asteroidFrequency >= 2.0{
                
                asteroidFrequency -= 0.5
                createAsteroids()
            }
            
            self.currentAsteroidRound = 0
        }
    }
    
    func earthSetup(){
        
        self.scene?.rootNode.addChildNode(earth.earthNode)
    }
    
    func sceneSetup() {
        let scene = SCNScene()
        
        scene.background.contents = #imageLiteral(resourceName: "spaceBackground")
        scene.physicsWorld.contactDelegate = self
        
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
            let omniLightNode = SCNNode()
            omniLightNode.light = SCNLight()
            omniLightNode.light!.type = SCNLight.LightType.omni
            omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
            omniLightNode.position = SCNVector3Make(0, 0, 50)
            scene.rootNode.addChildNode(omniLightNode)
        
        
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, -15)
        scene.rootNode.addChildNode(cameraNode)
        
        self.scene = scene
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld,didBegin contact: SCNPhysicsContact) {
        if (contact.nodeA == nil || contact.nodeB == nil){
            return
        }
        if (contact.nodeA.name == "earth" || contact.nodeA.name == "asteroid") && (contact.nodeB.name == "earth" || contact.nodeB.name == "asteroid") {
            
            //asteroidsTimer.invalidate()
            
            let miniExplosionEmitterNode = SCNNode()
            miniExplosionEmitterNode.position = contact.contactPoint
            miniExplosionEmitterNode.name = "explosion"
            //            let miniExplosionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(removeMiniExplosion as (miniExplosionNode:miniExplosionEmitterNode)), userInfo: nil, repeats: false)
            
            //
            let miniExplosionParticles = SCNParticleSystem(named: "miniExplosion.scnp", inDirectory: nil)!
            
            miniExplosionEmitterNode.addParticleSystem(miniExplosionParticles)
            self.scene?.rootNode.addChildNode(miniExplosionEmitterNode)
            
            miniExplosionEmitterNode.runAction(SCNAction.wait(duration: 1.0)){
                miniExplosionEmitterNode.removeFromParentNode()
            }
            
            
            if contact.nodeA.name == "asteroid"{
                remove(node: contact.nodeA)
                //contact.nodeA.removeFromParentNode()
                print("REMOVEU A")
            } else if contact.nodeB.name == "asteroid"{
                remove(node: contact.nodeB)
                //contact.nodeB.removeFromParentNode()
                print("REMOVEU B")
            }
            
            earth.wasHit()
            
            
            //            for node in (self.scene?.rootNode.childNodes)!{
            //                if node.name != "explosion"{
            //                node.removeFromParentNode()
            //                }
            //            }
            
        }
    }
    
    func removeMiniExplosion(miniExplosionNode: SCNNode){
        
        miniExplosionNode.removeFromParentNode()
    }
    
    func remove(node : SCNNode){
        DispatchQueue.main.async {
            node.removeFromParentNode()
            //self.performSegue(withIdentifier: "goToGameVC", sender: self)
        }
    }
    
}
