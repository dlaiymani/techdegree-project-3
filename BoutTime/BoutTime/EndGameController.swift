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
    var numberOfRounds: Int?
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Just display the score
        if let score = score, let numberOfRounds = numberOfRounds {
            scoreLabel.text = "\(score)/\(numberOfRounds)"
        } else {
            score = 0
            numberOfRounds = 0
        }
    }
    

    @IBAction func playAgainTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
