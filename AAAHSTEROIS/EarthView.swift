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
  }
  
  
  func earthSetup(){
    
    let earthSphere = SCNSphere(radius: 700)
    earthSphere.segmentCount = 250
    
    earthNode.geometry = earthSphere
    earthNode.position = SCNVector3Make(0, -290, -750)
    earthNode.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "specularMap")
    earthNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "colorMap")
    earthNode.geometry?.firstMaterial?.transparent.contents = #imageLiteral(resourceName: "cloudMap")
    
    self.scene?.rootNode.addChildNode(earthNode)
  }
  
  func sceneSetup() {
    let scene = SCNScene()
    
    scene.background.contents = UIColor.clear
    
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light!.type = SCNLight.LightType.ambient
    ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
    scene.rootNode.addChildNode(ambientLightNode)
    
    let omniLightNode = SCNNode()
    omniLightNode.light = SCNLight()
    omniLightNode.light!.type = SCNLight.LightType.omni
    omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
    omniLightNode.position = SCNVector3Make(0, 50, 50)
    scene.rootNode.addChildNode(omniLightNode)
    
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3Make(0, 0, 0)
    scene.rootNode.addChildNode(cameraNode)
    
    self.scene = scene
  }

}
