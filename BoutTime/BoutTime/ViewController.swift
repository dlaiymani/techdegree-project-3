//
//  ViewController.swift
//  BoutTime
//
//  Created by davidlaiymani on 21/03/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var eventsLabel: [UILabel]!
    @IBOutlet var upButtons: [UIButton]!
    @IBOutlet var downButtons: [UIButton]!

    
    let gameManager = GameManager(numberOfRounds: 4)
    var currentEvents: [Event]
    
    required init?(coder aDecoder: NSCoder) {
        self.currentEvents = gameManager.randomEvent()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        displayEvents()
        
    }


    // MARK: display the round
    func displayEvents() {
        for (index, event) in currentEvents.enumerated() {
            eventsLabel[index].text = event.title
        }
    }
    
    
    // MARK: manage the UI
    
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
        let buttonNumber = downButtons.index(where: {$0 == sender})
        if let buttonNumber = buttonNumber {
            currentEvents.swapAt(buttonNumber+1, buttonNumber)
            displayEvents()
        }
        print(buttonNumber)
    }
    
    
    @IBAction func upButtonTapped(_ sender: UIButton) {
        let buttonNumber = upButtons.index(where: {$0 == sender})
        if let buttonNumber = buttonNumber {
            currentEvents.swapAt(buttonNumber+1, buttonNumber)
            displayEvents()
        }

    }
}

