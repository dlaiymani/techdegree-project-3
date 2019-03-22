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
    @IBOutlet weak var infoLabel: UILabel!
    
    var timer = Timer()
    var secondsPerRound = 59


    let gameManager = GameManager(numberOfRounds: 4)
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()

        displayEvents()
        nextRoundButton.isHidden = true
    }
    
    // MARK: shake gesture management
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if gameManager.checkEventOrder() {
                timer.invalidate()
                timerLabel.isHidden = true
                let imageWrong = UIImage(named: "next_round_success")
                nextRoundButton.setImage(imageWrong, for: .normal)
                nextRoundButton.isHidden = false
            } else {
                timer.invalidate()
                timerLabel.isHidden = true
                let imageWrong = UIImage(named: "next_round_fail")
                nextRoundButton.setImage(imageWrong, for: .normal)
                nextRoundButton.isHidden = false
            }
            infoLabel.text = "Tap events to learn more"
        }
    }


    // MARK: display the round
    func displayEvents() {
        for (index, event) in gameManager.game.events.enumerated() {
            eventsLabel[index].text = "\(event.title) -> \(event.year)"
        }
        startTimer()
       // print(currentEvents.isSorted())

    }
    
    
    // MARK: manage the UI
    @IBAction func downButtonTapped(_ sender: UIButton) {
       // sender.isHighlighted = !sender.isHighlighted
        let buttonNumber = downButtons.index(where: {$0 == sender})
        if let buttonNumber = buttonNumber {
            gameManager.game.events.swapAt(buttonNumber+1, buttonNumber)
            displayEvents()
        }
     //   sender.isSelected = !sender.isSelected

        print(buttonNumber)
    }
    
    
    @IBAction func upButtonTapped(_ sender: UIButton) {
        let buttonNumber = upButtons.index(where: {$0 == sender})
        if let buttonNumber = buttonNumber {
            gameManager.game.events.swapAt(buttonNumber+1, buttonNumber)
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

