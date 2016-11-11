//
//  EarthView.swift
//  AAAHSTEROIS
//
//  Created by Gabriella Lopes on 08/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit
import SceneKit

class EarthView: SCNView {
  
  let earthNode = SCNNode()
  
  func load3DEarth(){
    
    sceneSetup()
    earthSetup()
    rotate()
  }
    
    func rotate() {
        earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 1, y: 1, z: 1, duration: 70)))
    }
  
  
  func earthSetup(){
    
    //raio 700
    let earthGeometry = SCNSphere(radius: 12)
    earthGeometry.segmentCount = 80
    //segment 250
    earthNode.geometry = earthGeometry
    earthNode.position = SCNVector3Make(0, -14, -20)
    earthNode.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "specularMap")
    earthNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "colorMap")
    
    self.scene?.rootNode.addChildNode(earthNode)
    
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
    scene.rootNode.addChildNode(cameraNode)
    
    self.scene = scene
  }

}
