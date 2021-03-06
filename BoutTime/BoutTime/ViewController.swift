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
    @IBOutlet var factsButtons: [UIButton]!
    @IBOutlet var upButtons: [UIButton]!
    @IBOutlet var downButtons: [UIButton]!
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var timer = Timer()
    let gameManager = HistoricalQuiz(numberOfQuestionsPerRound: 4, numberOfRounds: 6, secondsPerRound: 60)

    var timerSeconds = 0
    
    var testMode = false // allow to display years and so to test more easily
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()

        displayFacts()
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
            if gameManager.checkUserAnswer() { // user answer is correct i.e. sorted
                displayCorrectAnswer()
            } else {
                displayWrongAnswer()
            }
        }
    }


    // MARK: display the round
    func displayFacts() {
        for (index, event) in gameManager.questionsForRound.enumerated() {
            if testMode {
                factsButtons[index].setTitle("\(event.title) -> \(event.year)", for: .normal)
            } else {
                factsButtons[index].setTitle("\(event.title)", for: .normal)

            }
            factsButtons[index].isEnabled = false
        }
    }
    
    
    // MARK: manage the UI
    // If buttons down (or up) are tapped then swap the previous (or next) event
    // and dispaly again the events
    @IBAction func downButtonTapped(_ sender: UIButton) {
        let buttonNumber = downButtons.index(where: {$0 == sender})
        if let buttonNumber = buttonNumber {
            gameManager.questionsForRound.swapAt(buttonNumber+1, buttonNumber)
            displayFacts()
        }
    }
    
    
    @IBAction func upButtonTapped(_ sender: UIButton) {
        let buttonNumber = upButtons.index(where: {$0 == sender})
        if let buttonNumber = buttonNumber {
            gameManager.questionsForRound.swapAt(buttonNumber+1, buttonNumber)
            displayFacts()
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
            if gameManager.checkUserAnswer() {
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
        for button in factsButtons {
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
            gameManager.reinitQuiz()
            nextRoundButton.isHidden = true
            timerLabel.isHidden = false
            infoLabel.text = "Shake to complete"
            reinitTimer()
            displayFacts()
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
                webViewController.url = gameManager.questionsForRound[sender.tag].url            }
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

