//
//  GameViewController.swift
//  AAAHSTEROIS
//
//  Created by Wellington Bezerra on 07/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit
import GameplayKit
import GameController

class GameViewController: UIViewController {
    
    var gameScene = GameScene()
 

  @IBOutlet weak var earthView: SCNView!
  let earthNode = SCNNode()


    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as! SKView
      
        //let scene = SKScene(fileNamed: "GameScene")
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.presentScene(scene)
      
      //EARTH
      sceneSetup()
      earthSetup()

      earthView.scene?.rootNode.addChildNode(earthNode)
      
        
    }
  
  func earthSetup(){
    
    earthNode.geometry = SCNSphere(radius: 10)
    earthNode.position = SCNVector3Make(-2, 0, 0)
    earthNode.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "specularMap")
    earthNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "colorMap")
    earthNode.geometry?.firstMaterial?.transparent.contents = #imageLiteral(resourceName: "cloudMap")
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
    omniLightNode.position = SCNVector3Make(0, 50, 50)
    scene.rootNode.addChildNode(omniLightNode)
    
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3Make(0, 0, 25)
    scene.rootNode.addChildNode(cameraNode)
    
    earthView.scene = scene
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for item in presses {
            if item.type == .select {
                gameScene.count -= 1
                print("Count = \(gameScene.count)")
            }
        }
        if(gameScene.count == 2){
            print("voce precisa recarregar sua arma")
        }
    }
}
