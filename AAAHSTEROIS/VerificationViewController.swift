//
//  VerificationViewController.swift
//  AAAHSTEROIS
//
//  Created by Gabriella Lopes on 20/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {

  
  @IBOutlet weak var number0: UILabel!
  @IBOutlet weak var number1: UILabel!
  @IBOutlet weak var number2: UILabel!
  @IBOutlet weak var number3: UILabel!
  
  let code = "1234"

  
    override func viewDidLoad() {
        super.viewDidLoad()

      setCode()
    }

  func setCode(){
    
    var index = 0
    let codeNumbers = [number0,number1,number2,number3]
    
    for number in 0...3{
    //pega um caractere do string e seta em cada label
      codeNumbers[index]?.text = String(code[code.index(code.startIndex, offsetBy: number)])
      print(code[code.index(code.startIndex, offsetBy: number)])
      index += 1
    }
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
