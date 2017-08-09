//
//  GameViewController.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-12.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class GameViewController: UIViewController, SRCountdownTimerDelegate, GameViewDelegate {
    
    // MARK: - Protocol Methods
    func didTapQuitToMenu() {
        gameView.playAgainButton.removeFromSuperview()
        gameView.quitToMenuButton.removeFromSuperview()
        didTapQuitAnimations()
    }
    
    func didTapTryAgain() {
        restart()
        presentNextPerson()
        putIDCardDown()
    }
    
    func didTapApprove() {
        hideApproveDenyButtons()
        if personCanEnter.0 == true {
            score += 1
            slideOutIDCardAndPerson(.right)
        } else {
            gameover(for: personCanEnter.reason!)
        }
    }
    
    func didTapDeny() {
        hideApproveDenyButtons()
        if personCanEnter.0 == false {
            score += 1
            slideOutIDCardAndPerson(.left)
        } else {
            gameover(for: personCanEnter.reason!)
        }
    }
    
    func didTapStart() {
        restart()
        gameView.startButton.isHidden = true
        didTapStartAnimations()
    }
    
    func restart() {
        gameoverCardView.removeFromSuperview()
        gameView.playAgainButton.removeFromSuperview()
        gameView.quitToMenuButton.removeFromSuperview()
        score = 0
        level = 0
        setupLegalAgeLocale()
        selectRandomPerson()
    }
    
    // MARK: - Views
    let gameView = GameView()
    let IDCardView = IDCardContainerView()
    let gameoverCardView = GameoverView()
    
    // MARK: Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let components = Components.sharedComponentsData
    
    let defaults = UserDefaults.standard // User Defaults for storing highscore
    let highscoreKey = "highscore" // key for storing and retrieving highscore from user defaults
    
    var level: Int = 1
    
    var highScore: Int = 0
    
    var score: Int = 0 {
        didSet {
            let attributedScoreText = NSMutableAttributedString(string: "SCORE", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 10)])
            attributedScoreText.append(NSAttributedString(string: "\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 2)]))
            attributedScoreText.append(NSAttributedString(string: "\(score)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 34)]))
            gameView.scoreLabel.attributedText = attributedScoreText
            if score == 10 {
                level = 2
                gameView.rulesLabel.text?.append("\nNo Sunglasses")
            }
            if score == 15 {
                level = 3
                gameView.rulesLabel.text?.append("\nNo Hats")
            }
            if score == 20 {
                level = 4
                gameView.rulesLabel.text?.append("\nNo Ties")
            }
            if score == 25 {
                level = 5
            }
        }
    }
    
    func putIDCardDown() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            
            var transform = CATransform3DIdentity
            let divider: CGFloat = 500
            let degree: Double = 45
            let x: CGFloat = 1
            let y: CGFloat = 0
            let z: CGFloat = 0
            let anchorPointX = 0.5
            let anchorPointY = 0.5
            
            self.IDCardView.layer.anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
            
            transform = CATransform3DIdentity
            transform.m34 = -1.0/divider
            
            let rotateAngle = CGFloat((degree * Double.pi) / 180.0)
            transform = CATransform3DRotate(transform, rotateAngle, x, y, z)
            
            self.IDCardView.layer.transform = transform
            self.IDCardView.layer.zPosition = 80
            
            self.IDCardView.center.y = self.view.frame.size.height / 1.39
        })
    }
    
    func hideApproveDenyButtons() {
        gameView.denyButton.isHidden = true
        gameView.approveButton.isHidden = true
    }
    
    func showApproveDenyButtons() {
        gameView.denyButton.isHidden = false
        gameView.approveButton.isHidden = false
    }

    func presentNextPerson() {
        showApproveDenyButtons()
        slideInIDCardAndPerson()
        if level == 5 {
            gameView.circleTimer.start(beginningValue: 3)
        }
        if level == 3 {
            gameView.circleTimer.start(beginningValue: 4)
        } else {
            gameView.circleTimer.start(beginningValue: 5)
        }
    }
    
    // MARK: - Gameover
    fileprivate func gameover(for reason: GameoverReason) {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.personImageView.center.x = -self.view.bounds.width / 2
        })
        gameView.circleTimer.pause()
        hideApproveDenyButtons()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        flashRed()
        
        if score > highScore {
            highScore = score
            defaults.set(highScore, forKey: highscoreKey)
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            
            self.IDCardView.transform = .identity
            self.IDCardView.layer.zPosition = 80
            self.IDCardView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 20)
            
            self.gameoverCardView.highscoreLabel.text = "Highscore: \(self.highScore)"
            self.gameoverCardView.scoreLabel.text = "Score: \(self.score)"
            self.gameoverCardView.reasonLabel.text = reason.rawValue
            
            self.IDCardView.addSubview(self.gameoverCardView)
            self.gameoverCardView.anchor(top: self.IDCardView.topAnchor, left: self.IDCardView.leftAnchor, bottom: self.IDCardView.bottomAnchor, right: self.IDCardView.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 0, paddingRight: 2, width: 0, height: 0)
            
        }) { (_) in
            self.gameView.addSubview(self.gameView.playAgainButton)
            self.gameView.playAgainButton.anchor(top: self.gameoverCardView.bottomAnchor, left: self.gameoverCardView.leftAnchor, bottom: nil, right: self.gameoverCardView.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
            self.gameView.addSubview(self.gameView.quitToMenuButton)
            self.gameView.quitToMenuButton.anchor(top: self.gameView.playAgainButton.bottomAnchor, left: self.gameoverCardView.leftAnchor, bottom: nil, right: self.gameoverCardView.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameView.frame = self.view.bounds
        gameView.delegate = self
        
        gameView.frame = self.view.bounds
        view.addSubview(gameView)
        
        gameView.circleTimer.delegate = self
        
        highScore = defaults.object(forKey: highscoreKey) as? Int ?? 0
        
        setupLegalAgeLocale()
        setupIDCardPersonLayout()
    }
    
    var legalAge: Int?
    
    func setupLegalAgeLocale() {
        if locale == "CA" {
            gameView.rulesLabel.text = "Rules:\n19+"
            legalAge = 19
        } else {
            gameView.rulesLabel.text = "Rules:\n21+"
            legalAge = 21
        }
    }
    
  
    fileprivate func setupIDCardPersonLayout() {
        personImageView.frame.size = CGSize(width: view.frame.width * 0.48, height: view.frame.height * 0.42)
        personImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        personImageView.layer.position = CGPoint(x: -view.frame.width / 2, y: view.frame.height * 0.60)
        
        IDCardView.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 1.39)
        IDCardView.center.x -= view.bounds.width
        personImageView.center.x = -view.bounds.width * 2
        
        view.addSubview(IDCardView)
        view.addSubview(personImageView)
    }
    
    fileprivate func slideInIDCardAndPerson() {
       
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.IDCardView.center.x = self.view.bounds.width / 2
            self.personImageView.center.x = self.view.bounds.width / 2
        })
    }
    
    enum Direction {
        case right
        case left
    }
    
    fileprivate func slideOutIDCardAndPerson(_ direction: Direction) {
        let personOverlay = UIImageView(image: personImageView.image)
        personOverlay.frame.size = CGSize(width: view.frame.width * 0.48, height: view.frame.height * 0.42)
        personOverlay.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        personOverlay.layer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.60)
        view.addSubview(personOverlay)
       
        gameView.circleTimer.pause()
        func callNextPerson() {
            self.selectRandomPerson()
            self.presentNextPerson()
        }
        personImageView.center.x = -self.gameView.bounds.width / 2
        if direction == .right {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.IDCardView.center.x = self.gameView.bounds.width * 2
                personOverlay.center.x = self.gameView.bounds.width * 2
            }) { (_) in
                self.IDCardView.center.x = -self.gameView.bounds.width / 2
                personOverlay.removeFromSuperview()
                callNextPerson()
            }
        } else {
            if direction == .left {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    self.IDCardView.center.x = -self.gameView.bounds.width / 2
                    personOverlay.center.x = -self.gameView.bounds.width / 2
                }) { (_) in
                    callNextPerson()
                    personOverlay.removeFromSuperview()
                }
            }
        }
    }
    
    var personCanEnter: (Bool, reason: GameoverReason?) = (true, reason: nil)
    
    var personImageViewKey: String?
    var personImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        return iv
    }()
    
    // MARK: - New Person Setup
    var randomPerson: Person?
    var isWearingSunglasses = false
    var isWearingHat = false
    var isWearingTie = false
    
    // MARK: - Match Variables
    var isSamePerson: Bool?
    var isExpired: Bool?
    var isUnderage: Bool?
    
    fileprivate func selectRandomPerson() {
        let genderProbability = arc4random_uniform(10) + 1
        
        let personDictionary = genderProbability >= 5 ? components.buildPerson(gender: .female) : components.buildPerson(gender: .male)
        
        let randomPerson = Person(personDictionary: personDictionary, gender: genderProbability >= 5 ? .female : .male, level: level)
        isWearingSunglasses = randomPerson.isWearingSunglasses
        isWearingHat = randomPerson.isWearingHat
        isWearingTie = randomPerson.isWearingTie
        
        for (key, value) in randomPerson.avatarDictionary {
            personImageView.image = value
            personImageViewKey = key
        }
        
        let probabilityValue = arc4random_uniform(100) + 1
        if probabilityValue > 80 {
            personCanEnter = (false, .wrongID)
            
            let anotherGenderProbability = arc4random_uniform(10) + 1
            let anotherPersonDictionary = genderProbability >= 5 ? components.buildPerson(gender: .female) : components.buildPerson(gender: .male)
            let anotherRandomPerson = Person(personDictionary: anotherPersonDictionary, gender: anotherGenderProbability >= 5 ? .female : .male, level: level)
            IDCardView.person = anotherRandomPerson
        } else {
            IDCardView.person = randomPerson
            checkIfPersonCanEnter(person: randomPerson)
        }
    }
    
    let locale = Locale.current.regionCode
    
    fileprivate func checkIfPersonCanEnter(person: Person) {
        if isWearingSunglasses == true {
            personCanEnter = (false, .isWearingSunglasses)
            return
        }
        
        if isWearingHat == true {
            personCanEnter = (false, .isWearingHat)
            return
        }
        
        if isWearingTie == true {
            personCanEnter = (false, .isWearingTie)
            return
        }
        
        let currentTimestamp = Date().timeIntervalSince1970
        isExpired = currentTimestamp > person.expiryDateTimeStamp
        
        guard let legalAge = legalAge else { return }
        isUnderage = legalAge >= person.age
        
        if isExpired == true && isUnderage == true {
            personCanEnter = (false, .expiredAndUnderage)
            return
        } else if isExpired == true && isUnderage == false {
            personCanEnter = (false, .expiredID)
            return
        } else if isExpired == false && isUnderage == true {
            personCanEnter = (false, .underage)
            return
        } else {
            personCanEnter = (true, .expiredID)
        }
    }
    
    // MARK: - Timer
    func timerDidEnd() {
        gameover(for: .timerRanOutDuringPerson)
    }
}
