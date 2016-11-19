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
    
    func changeColor(color:String,number:Int){
        self.aim.texture = SKTexture(imageNamed: "mira\(color)\(number)")
    }
}
