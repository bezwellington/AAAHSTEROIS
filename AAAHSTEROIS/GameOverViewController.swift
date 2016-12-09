//
//  GameOverViewController.swift
//  AAAHSTEROIS
//
//  Created by Gabriella Lopes on 11/28/16.
//  Copyright © 2016 Wellington Bezerra. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    
    @IBOutlet weak var finalScore: UILabel!
    var finalScoreNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        finalScore.text = String(finalScoreNumber)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
