//
//  CGVectorExtension.swift
//  AAAHSTEROIS
//
//  Created by Gabrielle Brandenburg dos Anjos on 19/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit

extension CGVector {
    mutating func applyModule (speed: CGFloat){
        self.dx = speed*self.dx
        self.dy = speed*self.dy
    }
}
