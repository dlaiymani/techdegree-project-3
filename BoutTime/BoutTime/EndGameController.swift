//
//  EndGameController.swift
//  BoutTime
//
//  Created by davidlaiymani on 22/03/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

class EndGameController: UIViewController {

    var score: Int?
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let score = score {
            scoreLabel.text = "\(score)/6"
        } else {
            score = 0
        }
    }
    

    @IBAction func playAgainTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
