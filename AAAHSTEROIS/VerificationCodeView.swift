//
//  VerificationCodeView.swift
//  AAAHSTEROIS
//
//  Created by Gabrielle Brandenburg dos Anjos on 08/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit

class VerificationCodeView: UIView {
    
    var codeLabel = UILabel()
    
    var verificationCode: String!
    
    var h: CGFloat!
    var w: CGFloat!
    
    init(frame: CGRect, verificationCode: String){
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.draw(self.frame)
        
        self.h = frame.height
        self.w = frame.width
        
        self.verificationCode = verificationCode
        
        setupCodeLabel()
    }
    
    func setupCodeLabel(){
    
        codeLabel.text = verificationCode
        codeLabel.frame = CGRect(x: 0.3*w, y: 0.5*h, width: 0.3*w, height: 0.3*h)
        
        codeLabel.font = codeLabel.font.withSize(76)
        codeLabel.adjustsFontSizeToFitWidth = true
        
        
        self.addSubview(codeLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
