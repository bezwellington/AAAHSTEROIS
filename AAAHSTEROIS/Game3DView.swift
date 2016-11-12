//
//  EarthView.swift
//  AAAHSTEROIS
//
//  Created by Gabriella Lopes on 08/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit
import SceneKit

class Game3DView: SCNView {
  
  let earthNode = SCNNode()
  let possibleAsteroidColor:[UIColor] = [UIColor.cyan, UIColor.yellow]
  
  func loadGame(){
    
    sceneSetup()
    earthSetup()
  
    createAsteroidsTimer()
    
  }
  
  
  func createAsteroidsTimer() {
    
    let asteroidsTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(addAsteroid), userInfo: nil, repeats: true)
    
    asteroidsTimer.fire()
    
    print("created 3d asteroid timer")
  }
  
  func animateAsteroid(asteroidNode:SCNNode, xPosition:Float){
    
    asteroidNode.runAction(SCNAction.move(to: SCNVector3Make(xPosition, -5, -20), duration: 4)){
      asteroidNode.removeFromParentNode()
      print("removed 3d asteroid")
    }
  }
  
  func addAsteroid(){
    
    let asteroidNode = SCNNode()
    let asteroidGeometry = SCNSphere(radius: 0.2)
    asteroidNode.geometry = asteroidGeometry
    
    let randomX = Float(arc4random_uniform(10))

    asteroidNode.position = SCNVector3Make(randomX-5, 4,-20)
    asteroidNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "asteroidMaterial1")
    
    let asteroidFire = SCNParticleSystem(named: "fire.scnp", inDirectory: nil)!
    
    let randomColor = Int(arc4random_uniform(UInt32(possibleAsteroidColor.count)))
    
    asteroidFire.particleColor = possibleAsteroidColor[randomColor]
    asteroidNode.addParticleSystem(asteroidFire)
    
    self.scene?.rootNode.addChildNode(asteroidNode)
    
    
    print("created 3d asteroid")
    animateAsteroid(asteroidNode: asteroidNode, xPosition: randomX-5)
    
  }
  
  func earthSetup(){
    
    let earthGeometry = SCNSphere(radius: 12)
    earthGeometry.segmentCount = 80

    earthNode.geometry = earthGeometry
    earthNode.position = SCNVector3Make(0, -14, -20)
    earthNode.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "specularMap")
    earthNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "colorMap")
    
    self.scene?.rootNode.addChildNode(earthNode)
    
    earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 1, y: 1, z: 1, duration: 70)))

    
    //CLOUDS
 
//    let cloudGeometry = SCNSphere(radius:12.5) //730
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
    
    scene.background.contents = UIColor.black
    
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
    //cameraNode.rotation = SCNVector4Make(1, 0, 0, -0.2)
    scene.rootNode.addChildNode(cameraNode)
    
    self.scene = scene
  }

}
