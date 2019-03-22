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
    var secondsPerRound = 30
    
    var currentRound = 1
    var score = 0


    let gameManager = GameManager(numberOfRounds: 4)
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()

        displayEvents()
        nextRoundButton.isHidden = true
        startTimer()
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
                displayCorrectAnswer()
            } else {
                displayWrongAnswer()
            }
        }
    }


    // MARK: display the round
    func displayEvents() {
        for (index, event) in gameManager.game.events.enumerated() {
            eventsLabel[index].text = "\(event.title) -> \(event.year)"
        }
    }
    
    
    // MARK: manage the UI
    @IBAction func downButtonTapped(_ sender: UIButton) {
       // sender.isHighlighted = !sender.isHighlighted
        let buttonNumber = downButtons.index(where: {$0 == sender})
        if let buttonNumber = buttonNumber {
            gameManager.game.events.swapAt(buttonNumber+1, buttonNumber)
            displayEvents()
        }
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
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(self.changeTimerLabel),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    // Function called each second by the timer
    @objc func changeTimerLabel()
    {
        // End of the timer (i.e. 60s)
       if secondsPerRound == 0  || secondsPerRound < 0 {
            // Need to check if the answer is correct
            if gameManager.checkEventOrder() {
                displayCorrectAnswer()
            } else {
                displayWrongAnswer()
            }
        } else {
            secondsPerRound -= 1
            timerLabel.text = "0:\(String(format: "%02d", secondsPerRound))"
        }
    }
    
    // Re-init the timer
    func reinitTimer() {
        timer.invalidate()
        secondsPerRound = 30
        startTimer()
    }
    
    
    // MARK: Next round management
 
    func displayCorrectAnswer() {
        timer.invalidate()
        timerLabel.isHidden = true
        let imageSuccess = UIImage(named: "next_round_success")
        nextRoundButton.setImage(imageSuccess, for: .normal)
        nextRoundButton.isHidden = false
        infoLabel.text = "Tap events to learn more"
        score += 1
    }
    
    func displayWrongAnswer() {
        timer.invalidate()
        timerLabel.isHidden = true
        let imageWrong = UIImage(named: "next_round_fail")
        nextRoundButton.setImage(imageWrong, for: .normal)
        nextRoundButton.isHidden = false
        infoLabel.text = "Tap events to learn more"
    }
    
    
    func prepareNextRound() {
        currentRound += 1
        if currentRound <= 2 {
            gameManager.reinitGame()
            nextRoundButton.isHidden = true
            timerLabel.isHidden = false
            infoLabel.text = "Shake to complete"
            reinitTimer()
            displayEvents()
        } else {
            print("end game")
            performSegue(withIdentifier: "EndOfGame", sender: nil)
        }
    }
    
    @IBAction func nextRoundButtonTapped(_ sender: UIButton) {
        prepareNextRound()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EndOfGame" {
            if let endGameController = segue.destination as? EndGameController {
                endGameController.score = score
            }
        }
    }
    
    // MARK: Naviguation
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        currentRound = 0
        score = 0
        prepareNextRound()
        
    }
}

