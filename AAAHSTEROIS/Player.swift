//
//  Player.swift
//  AAAHSTEROIS
//
//  Created by Gabrielle Brandenburg dos Anjos on 19/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import SpriteKit

class Player {
    
    
    var coordinate: CGPoint!
    var laser: SKSpriteNode!
    var energy: Int!
    
    let category: Int = 1
    let color: String!
    let name: String!
    
    
    init(coordinate: CGPoint, color: String, name: String){
        
        self.energy = 8
        self.coordinate = coordinate
        self.color = color
        self.name = name
        self.laser = setupLaser(color: color)
    }
    
    func setupLaser(color: String) -> SKSpriteNode{
        let laser = SKSpriteNode(texture: SKTexture(imageNamed:"mira\(color)8"))
        laser.physicsBody = SKPhysicsBody(circleOfRadius: laser.size.width/2)
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.velocity = CGVector.zero
        
        return laser
    }
    
    func shoot() {
        energy = energy - 1;
        
        let texture = "mira\(color)\(energy)"
        
        self.laser.texture = SKTexture(imageNamed: texture)
    }
    
    func recharge() {
        energy = energy + 4
        if energy > 8 { energy = 8 }
        
        let texture = "mira\(color)\(energy)"
        
        self.laser.texture = SKTexture(imageNamed: texture)
    }
    
    func move(direction: CGVector) {
        self.laser.physicsBody?.velocity = direction
    }
    
}

