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
    @IBOutlet var eventsButtons: [UIButton]!
    @IBOutlet var upButtons: [UIButton]!
    @IBOutlet var downButtons: [UIButton]!
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var timer = Timer()
    let gameManager = GameManager(numberOfRounds: 2, eventsPerRound: 4, secondsPerRound: 30)
    var timerSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()

        displayEvents()
        nextRoundButton.isHidden = true
        timerSeconds = gameManager.secondsPerRound
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
            if gameManager.checkEventOrder() { // user answer is correct i.e. sorted
                displayCorrectAnswer()
            } else {
                displayWrongAnswer()
            }
        }
    }


    // MARK: display the round
    func displayEvents() {
        for (index, event) in gameManager.game.events.enumerated() {
            eventsButtons[index].setTitle("\(event.title) -> \(event.year)", for: .normal)
            eventsButtons[index].isEnabled = false
        }
    }
    
    
    // MARK: manage the UI
    // If buttons down (or up) are tapped then swap the previous (or next) event
    // and dispaly again the events
    @IBAction func downButtonTapped(_ sender: UIButton) {
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
        timerLabel.text = "0:\(timerSeconds)"
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(self.changeTimerLabel),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // Function called each second by the timer
    @objc func changeTimerLabel()
    {
        // End of the timer (i.e. 60s)
       if timerSeconds == 0  || timerSeconds < 0 {
            // Need to check if the answer is correct
            if gameManager.checkEventOrder() {
                displayCorrectAnswer()
            } else {
                displayWrongAnswer()
            }
        } else {
            timerSeconds -= 1
            timerLabel.text = "0:\(String(format: "%02d", timerSeconds))"
        }
    }
    
    // Re-init the timer
    func reinitTimer() {
        timer.invalidate()
        timerSeconds = gameManager.secondsPerRound
        startTimer()
    }
    
    
    // MARK: Next round management
    func enableButtons() {
        for button in eventsButtons {
            button.isEnabled = true
        }
    }
    
    // Change the buttons and the text
    func displayCorrectAnswer() {
        SoundManager.playCorrectAnswerSound()
        timer.invalidate()
        timerLabel.isHidden = true
        let imageSuccess = UIImage(named: "next_round_success")
        nextRoundButton.setImage(imageSuccess, for: .normal)
        nextRoundButton.isHidden = false
        infoLabel.text = "Tap events to learn more"
        gameManager.score += 1
        enableButtons()
    }
    
    func displayWrongAnswer() {
        SoundManager.playIncorrectAnswerSound()
        timer.invalidate()
        timerLabel.isHidden = true
        let imageWrong = UIImage(named: "next_round_fail")
        nextRoundButton.setImage(imageWrong, for: .normal)
        nextRoundButton.isHidden = false
        infoLabel.text = "Tap events to learn more"
        enableButtons()
    }
    
    func prepareNextRound() {
        gameManager.currentRound += 1
        if gameManager.currentRound <= gameManager.numberOfRounds {
            gameManager.reinitGame()
            nextRoundButton.isHidden = true
            timerLabel.isHidden = false
            infoLabel.text = "Shake to complete"
            print(gameManager.score)
            reinitTimer()
            displayEvents()
        } else { // End of the game
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
                endGameController.score = gameManager.score
                endGameController.numberOfRounds = gameManager.numberOfRounds
            }
        } else { // WebView Segue
            if let navigationViewController = segue.destination as? UINavigationController,
                 let webViewController = navigationViewController.topViewController as? WebViewController , let sender = sender as? UIButton {
                webViewController.url = gameManager.game.events[sender.tag].url            }
        }
    }
    
    // MARK: Naviguation
    
    // Back from EndOfGameController -> new round
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        gameManager.currentRound = 0
        gameManager.score = 0
        prepareNextRound()
    }
}

