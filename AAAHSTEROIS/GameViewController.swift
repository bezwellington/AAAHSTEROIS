//
//  GameViewController.swift
//  AAAHSTEROIS
//
//  Created by Wellington Bezerra on 07/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameController

class GameViewController: UIViewController {
    /*
        var originalPanViewCenter: CGPoint?
        var panViewConstraintCenterX: NSLayoutConstraint!
        var panViewConstraintCenterY: NSLayoutConstraint!
 */
 

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
        
        /*
        originalPanViewCenter = CGPoint(x: panViewConstraintCenterX.constant, y: panViewConstraintCenterY.constant)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "userPanned:")
        skView.addGestureRecognizer(panGestureRecognizer)
 */

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
