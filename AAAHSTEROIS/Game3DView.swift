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
  
    let earthNode = SCNNode()
    let possibleAsteroidColor:[UIColor] = [UIColor.cyan, UIColor.yellow]
    let asteroidCategory: Int = 1
    let earthCategory: Int = 2
  
    var asteroidFrequency = 3.0
    var currentAsteroidRound = 0
    var asteroidsTimer = Timer()

  
  func loadGame(){
    self.delegate = self
    sceneSetup()
    earthSetup()
    createAsteroidsTimer()
  }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        print(scene?.rootNode.childNodes.count)
    }
  
  func createAsteroidsTimer() {
    
    if asteroidsTimer.isValid {
      
      asteroidsTimer.invalidate()
    }
    
    asteroidsTimer = Timer()
    
    self.asteroidsTimer = Timer.scheduledTimer(timeInterval: self.asteroidFrequency, target: self, selector: #selector(addAsteroid), userInfo: nil, repeats: true)
    
    asteroidsTimer.fire()
    //print("created 3d asteroid timer")
  }
  
  func animateAsteroid(asteroidNode:SCNNode, xPosition:Float){
    
    let asteroidSpeed = Float(arc4random_uniform(6)) + 4.5
    
    asteroidNode.runAction(SCNAction.move(to: SCNVector3Make(xPosition, -5, -20), duration: TimeInterval(asteroidSpeed))){
      asteroidNode.removeFromParentNode()
      //print("removed 3d asteroid")
    }
  }
  
  func addAsteroid(){
    
    let asteroidNode = SCNNode()
    let asteroidGeometry = SCNSphere(radius: 0.2)
    asteroidNode.geometry = asteroidGeometry
    
    asteroidNode.name = "asteroid"
    asteroidNode.physicsBody = SCNPhysicsBody.kinematic()
    asteroidNode.physicsBody?.contactTestBitMask = earthCategory
    
    let randomX = Float(arc4random_uniform(10))

    asteroidNode.position = SCNVector3Make(randomX-5, 4,-20)
    asteroidNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "asteroidMaterial1")

    let asteroidFire = SCNParticleSystem(named: "fire.scnp", inDirectory: nil)!
    
    let randomColor = Int(arc4random_uniform(UInt32(possibleAsteroidColor.count)))
    
    asteroidFire.particleColor = possibleAsteroidColor[randomColor]
    asteroidNode.addParticleSystem(asteroidFire)
    
    self.scene?.rootNode.addChildNode(asteroidNode)
    
    self.currentAsteroidRound += 1
    
    if self.currentAsteroidRound == 10{
      
      if asteroidFrequency >= 2.0{
      asteroidFrequency -= 0.5
      createAsteroidsTimer()
      }
      self.currentAsteroidRound = 0
    }
    
    
    //print("created 3d asteroid")
    animateAsteroid(asteroidNode: asteroidNode, xPosition: randomX-5)
    
  }
  
  func earthSetup(){
    
    let earthGeometry = SCNSphere(radius: 12)
    earthGeometry.segmentCount = 80

    earthNode.geometry = earthGeometry
    earthNode.position = SCNVector3Make(0, -14, -20)
    earthNode.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "specularMap")
    earthNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "colorMap")
    earthNode.name = "earth"
    earthNode.physicsBody = SCNPhysicsBody.kinematic()
    earthNode.physicsBody?.categoryBitMask = earthCategory

    self.scene?.rootNode.addChildNode(earthNode)
    
    earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 1, y: 1, z: 1, duration: 70)))

    
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
  
  func sceneSetup() {
    let scene = SCNScene()

    scene.background.contents = #imageLiteral(resourceName: "spaceBackground")
    scene.physicsWorld.contactDelegate = self
    
    
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light!.type = SCNLight.LightType.ambient
    ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
    scene.rootNode.addChildNode(ambientLightNode)
    
//    let omniLightNode = SCNNode()
//    omniLightNode.light = SCNLight()
//    omniLightNode.light!.type = SCNLight.LightType.omni
//    omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
//    omniLightNode.position = SCNVector3Make(0, 0, 50)
//    scene.rootNode.addChildNode(omniLightNode)
    
    let directionalLightNode = SCNNode()
    directionalLightNode.light = SCNLight()
    directionalLightNode.light!.type = SCNLight.LightType.spot
    directionalLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
    directionalLightNode.position = SCNVector3Make(0, 10, -20)
    directionalLightNode.constraints?.append(SCNLookAtConstraint(target: earthNode))
    directionalLightNode.light!.castsShadow = true
    directionalLightNode.light!.shadowColor = UIColor.black

    scene.rootNode.addChildNode(directionalLightNode)

    
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3Make(0, 0, -15)
    //cameraNode.rotation = SCNVector4Make(1, 0, 0, -0.2)
    scene.rootNode.addChildNode(cameraNode)
    
    self.scene = scene
  }
    
    func physicsWorld(_ world: SCNPhysicsWorld,didBegin contact: SCNPhysicsContact) {
        if (contact.nodeA == nil || contact.nodeB == nil){
            return
        }
        if (contact.nodeA.name == "earth" || contact.nodeA.name == "asteroid") && (contact.nodeB.name == "earth" || contact.nodeB.name == "asteroid") {
            
            //asteroidsTimer.invalidate()
            
            let emitterNode = SCNNode()
            emitterNode.position = contact.contactPoint
            emitterNode.name = "explosion"
            
            let explosionParticles = SCNParticleSystem(named: "miniExplosion.scnp", inDirectory: nil)!

            emitterNode.addParticleSystem(explosionParticles)
            self.scene?.rootNode.addChildNode(emitterNode)

            if contact.nodeA.name == "asteroid"{
             remove(node: contact.nodeA)
                //contact.nodeA.removeFromParentNode()
                print("REMOVEU A")
            } else if contact.nodeB.name == "asteroid"{
                remove(node: contact.nodeB)
                //contact.nodeB.removeFromParentNode()
                print("REMOVEU B")
            }
            
//            for node in (self.scene?.rootNode.childNodes)!{
//                if node.name != "explosion"{
//                node.removeFromParentNode()
//                }
//            }

        }
    }
    
    func remove(node : SCNNode){
        DispatchQueue.main.async {
            node.removeFromParentNode()
            //self.performSegue(withIdentifier: "goToGameVC", sender: self)
        }
    }

}
