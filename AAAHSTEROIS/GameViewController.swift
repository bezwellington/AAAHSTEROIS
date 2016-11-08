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
    /*
        var originalPanViewCenter: CGPoint?
        var panViewConstraintCenterX: NSLayoutConstraint!
        var panViewConstraintCenterY: NSLayoutConstraint!
 */
 
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
      
      earthNode.geometry = SCNSphere(radius: 10)
      earthNode.position = SCNVector3Make(-2, 0, 0)
      earthNode.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "specularMap")
      earthNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "colorMap")
      earthNode.geometry?.firstMaterial?.transparent.contents = #imageLiteral(resourceName: "cloudMap")

      earthView.scene?.rootNode.addChildNode(earthNode)
      
        
        /*
        originalPanViewCenter = CGPoint(x: panViewConstraintCenterX.constant, y: panViewConstraintCenterY.constant)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "userPanned:")
        skView.addGestureRecognizer(panGestureRecognizer)
 */

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
    
    // MARK: UIPanGestureRecognizer
/*
    func userPanned(panGestureRecognizer : UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.view)
        print(translation)
        guard let originalCenter = originalPanViewCenter else { return }
        panViewConstraintCenterX.constant = originalCenter.x
        panViewConstraintCenterY.constant = originalCenter.y
        
        if (panGestureRecognizer.state == .changed) {
            panViewConstraintCenterX.constant += translation.x
            panViewConstraintCenterY.constant += translation.y
        }
    }
 */
    
    
    
}
