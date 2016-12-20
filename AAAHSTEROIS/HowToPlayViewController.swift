//
//  HowToPlayViewController.swift
//  AAAHSTEROIS
//
//  Created by Gabriella Lopes on 20/12/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit

class HowToPlayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  @IBAction func pressedGotIt(_ sender: Any) {
    
    performSegue(withIdentifier: "howToPlayGoToGame", sender: self)
  }


}
