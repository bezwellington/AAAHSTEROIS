//
//  Aim.swift
//  AAAHSTEROIS
//
//  Created by Wellington Bezerra on 13/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameplayKit

class AimClass {
    
    var aim = SKSpriteNode(imageNamed: "miraverde8")
    let aimCategory: Int = 1
    let shakeLabel = SKLabelNode(text: "SHAKE")
    
    
    init() {
        
        setShakeLabel()
        self.aim.addChild(shakeLabel)
    }
    
    func changeColor(color:String,number:Int){
        self.aim.texture = SKTexture(imageNamed: "mira\(color)\(number)")
        
        if number == 0{
            
            shakeLabel.isHidden = false
        } else {
            shakeLabel.isHidden = true
        }
        
    }
    
    func setShakeLabel(){
        
        shakeLabel.fontColor = UIColor.white
        shakeLabel.fontSize = 62.0
        shakeLabel.fontName = ".SFUIDisplay-Bold"
        shakeLabel.horizontalAlignmentMode = .center
        shakeLabel.verticalAlignmentMode = .center
        
        shakeLabel.isHidden = true
        

    }
}
