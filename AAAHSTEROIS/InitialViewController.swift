//
//  InitialViewController.swift
//  AAAHSTEROIS
//
//  Created by Gabriella Lopes on 13/11/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

  @IBOutlet weak var createMatchButton: UIButton!
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()


  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

  }
    
    @IBAction func pressedCreateAMatch(_ sender: AnyObject) {
        singlePlayer = false
        performSegue(withIdentifier: "goToCreateAMatch", sender: self)
    }

    @IBAction func pressedSinglePlayer(_ sender: Any) {
        singlePlayer = true
        performSegue(withIdentifier: "mainGoToHowToPlay", sender: self)
    }
}
