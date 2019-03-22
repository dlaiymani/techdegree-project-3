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
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer = Timer()
    var secondsPerRound = 59


    let gameManager = GameManager(numberOfRounds: 4)
    var currentEvents: [Event]
    
    required init?(coder aDecoder: NSCoder) {
        self.currentEvents = gameManager.randomEvent()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        displayEvents()
        nextRoundButton.isHidden = true
    }


    // MARK: display the round
    func displayEvents() {
        for (index, event) in currentEvents.enumerated() {
            eventsLabel[index].text = event.title
        }
        startTimer()

    }
    
    
    // MARK: manage the UI
    @IBAction func downButtonTapped(_ sender: UIButton) {
       // sender.isHighlighted = !sender.isHighlighted
        let buttonNumber = downButtons.index(where: {$0 == sender})
        if let buttonNumber = buttonNumber {
            currentEvents.swapAt(buttonNumber+1, buttonNumber)
            displayEvents()
        }
     //   sender.isSelected = !sender.isSelected

        print(buttonNumber)
    }
    
    
    @IBAction func upButtonTapped(_ sender: UIButton) {
        let buttonNumber = upButtons.index(where: {$0 == sender})
        if let buttonNumber = buttonNumber {
            currentEvents.swapAt(buttonNumber+1, buttonNumber)
            displayEvents()
        }

    }
    
    
    // MARK: Timer
    func startTimer() {
        timerLabel.text = "0:\(secondsPerRound)"
        timer = Timer.scheduledTimer(timeInterval: 1 ,
                                     target: self,
                                     selector: #selector(self.changeTimerLabel),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // Function called eaxh second by the timer
    @objc func changeTimerLabel()
    {
        // End of the timer (i.e. 60s)
        if secondsPerRound == 0  || secondsPerRound < 0 {
            timer.invalidate()
            
            // FIXME: manage the end of the timer
            //answerLabel.text = "Sorry, Too Late"
            //loadNextRound(delay: 2)
            
        } else {
            secondsPerRound -= 1
            timerLabel.text = "0:\(secondsPerRound)"
        }
    }
    
    // Re-init the timer
    func reinitTimer() {
        timer.invalidate()
        secondsPerRound = 60
    }
}

