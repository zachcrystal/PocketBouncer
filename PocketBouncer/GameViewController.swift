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

class GameViewController: UIViewController, SRCountdownTimerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let components = Components.sharedComponentsData
    
    
    // MARK: - Match Variables
    var isSamePerson: Bool?
    var isExpired: Bool?
    var isLegal: Bool?
    
    // MARK: - Isolated Properties
    
    var people: [Person]?
    
    let defaults = UserDefaults.standard
    let highscoreKey = "highscore"
    
    var highScore: Int = 0
    
    var score: Int = 0 {
        didSet {
            let attributedScoreText = NSMutableAttributedString(string: "SCORE", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 10)])
            attributedScoreText.append(NSAttributedString(string: "\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 2)]))
            attributedScoreText.append(NSAttributedString(string: "\(score)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 34)]))
            scoreLabel.attributedText = attributedScoreText
            
        }
    }
    
    // MARK: - UIKit Components
    
    
    var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play Free Mode", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.purple, for: .normal)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        return button
    }()
    
    var scoreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedScoreText = NSMutableAttributedString(string: "SCORE", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 10)])
        attributedScoreText.append(NSAttributedString(string: "\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 2)]))
        attributedScoreText.append(NSAttributedString(string: "0", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 34)]))
        label.attributedText = attributedScoreText
        label.textColor = .white
        return label
    }()
    
    var personImageViewKey: String?
    var personImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.image = #imageLiteral(resourceName: "placeholder")
        return iv
    }()
    
    var personShadow: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "RedShadow")
        return iv
    }()
    
    let denyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "deny"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        button.isHidden = true
        button.tag = 0
        return button
    }()
    
    let approveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "approve"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        button.isHidden = true
        button.tag = 1
        return button
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Background2")
        return iv
    }()
    
    let tableImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Table")
        return iv
    }()
    
    let thumbImageView: UIImageView = {
        let iv = UIImageView()
        iv.alpha = 0
        return iv
    }()
    
    let playAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.setTitle("TRY AGAIN", for: .normal)
        button.titleLabel?.textColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        button.tintColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 3
        button.layer.zPosition = 1500
        button.addTarget(self, action: #selector(handlePlayAgain), for: .touchUpInside)
        return button
    }()
    
    let quitToMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.setTitle("QUIT TO MENU", for: .normal)
        button.titleLabel?.textColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        button.tintColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 3
        button.layer.zPosition = 1500
        button.addTarget(self, action: #selector(handleMainMenuState), for: .touchUpInside)
        return button
    }()

    
    // MARK: - Action Selectors
    
    func handlePlayAgain() {
        gameoverCard.removeFromSuperview()
        playAgainButton.removeFromSuperview()
        quitToMenuButton.removeFromSuperview()
        score = 0
        selectRandomPerson()
        presentNextPerson()
        putIDCardDown()
    }
    
    fileprivate func putIDCardDown() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            
            var transform = CATransform3DIdentity
            let divider: CGFloat = 500
            let degree: Double = 45
            let x: CGFloat = 1
            let y: CGFloat = 0
            let z: CGFloat = 0
            let anchorPointX = 0.5
            let anchorPointY = 0.5
            
            self.IDCardContainer.layer.anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
            
            transform = CATransform3DIdentity
            transform.m34 = -1.0/divider
            
            let rotateAngle = CGFloat((degree * Double.pi) / 180.0)
            transform = CATransform3DRotate(transform, rotateAngle, x, y, z)
            
            self.IDCardContainer.layer.transform = transform
            self.IDCardContainer.layer.zPosition = 80
            
            self.IDCardContainer.center.y = self.view.frame.size.height / 1.39

        }) { (_) in
            
        }

    }
    
    
    // MARK: - Menu Screen
    func handleMainMenuState() {
        
        playAgainButton.removeFromSuperview()
        quitToMenuButton.removeFromSuperview()
        
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.IDCardContainer.center.x = -self.view.bounds.width / 2
        }) { (_) in
            self.IDCardContainer.center.y = self.view.frame.size.height / 1.39

        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.personImageView.center.x = -self.view.bounds.width / 2
        }) { (_) in

        }

        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.tableImageView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height * 0.4)
        }) { (_) in
            // left completion if needed
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.6, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
            self.denyButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
            self.denyButton.isHidden = true
        }) { (_) in
            self.putIDCardDown()
        }
        
        
        approveButton.isHidden = false
        UIView.animate(withDuration: 1.0, delay: 0.8, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
            self.approveButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
            self.approveButton.isHidden = true
        }) { (_) in
            self.startButton.isHidden = false
        }
    }
    
    func handleStart() {
        gameoverCard.removeFromSuperview()
        playAgainButton.removeFromSuperview()
        quitToMenuButton.removeFromSuperview()
        score = 0
        selectRandomPerson()
        startButton.isHidden = true

        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.tableImageView.frame = CGRect(x: 0, y: self.view.bounds.height * 0.60, width: self.view.bounds.width, height: self.view.bounds.height * 0.4)
        }) { (_) in
            // left completion if needed
        }
        
        denyButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
        denyButton.isHidden = false
        UIView.animate(withDuration: 1.0, delay: 0.6, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
            self.denyButton.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }) { (_) in
            // left completion if needed
        }
        
        approveButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
        approveButton.isHidden = false
        UIView.animate(withDuration: 1.0, delay: 0.8, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
            self.approveButton.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        }) { (_) in
            self.presentNextPerson()
            self.circleTimer.start(beginingValue: 5)
        }
    }
    
    func hideApproveDenyButtons() {
        denyButton.isHidden = true
        approveButton.isHidden = true
    }
    
    func unhideApproveDenyButtons() {
        denyButton.isHidden = false
        approveButton.isHidden = false
    }
    
    func handleMatch(sender: UIButton) {
        hideApproveDenyButtons()
        
        // deny tag = 0, approve tag = 1
        
        var isMatch = Bool()
        guard let IDCardViewKey = IDCardContainer.IDCard.identificationImageKey else { return }
        
        if personImageViewKey == IDCardViewKey && isExpired == false && isLegal == true {
            isMatch = true
        } else {
            isMatch = false
        }
        
        if isMatch == true && sender.tag == 0 {
            gameover(for: GameoverReason.falseDeny)
            flashRed()
        }
        
        if isMatch == true && sender.tag == 1  {
            score += 1
            slideOutIDCardAndPerson(.right)
            
        }
        
        if isMatch == false && sender.tag == 0 {
            score += 1
            slideOutIDCardAndPerson(.left)
            
        }
        
        if isMatch == false && sender.tag == 1 {
            if personImageViewKey != IDCardViewKey {
                gameover(for: .wrongID)
                flashRed()
                return
            } else if isExpired == true && isLegal == false {
                gameover(for: .expiredAndUnderage)
            } else if isExpired == false && isLegal == false {
                gameover(for: .underage)
            } else if isExpired == true && isLegal == true {
                gameover(for: .expiredID)
            }
            flashRed()
        }
    }
    
    func presentNextPerson() {
        unhideApproveDenyButtons()
        slideInIDCardAndPerson()
        circleTimer.start(beginingValue: 5)
    }
    
    // MARK: - Gameover
    
    let gameoverCard = GameoverView()
    fileprivate func gameover(for reason: GameoverReason) {
        circleTimer.pause()
        hideApproveDenyButtons()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        flashRed()
        
        if score > highScore {
            highScore = score
            defaults.set(highScore, forKey: highscoreKey)
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            
            var transform = CATransform3DIdentity
            let divider: CGFloat = 500
            let degree: Double = 0
            let x: CGFloat = 1
            let y: CGFloat = 0
            let z: CGFloat = 0
            let anchorPointX = 0.5
            let anchorPointY = 0.5
            
            self.IDCardContainer.layer.anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
            
            transform = CATransform3DIdentity
            transform.m34 = -1.0/divider
            
            let rotateAngle = CGFloat((degree * Double.pi) / 180.0)
            transform = CATransform3DRotate(transform, rotateAngle, x, y, z)
            
            self.IDCardContainer.layer.transform = transform
            self.IDCardContainer.layer.zPosition = 80
            
            self.IDCardContainer.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 20)
            
            self.gameoverCard.highscoreLabel.text = "Highscore: \(self.highScore)"
            self.gameoverCard.scoreLabel.text = "Score: \(self.score)"
            self.gameoverCard.reasonLabel.text = reason.rawValue
            self.IDCardContainer.addSubview(self.gameoverCard)
            self.gameoverCard.anchor(top: self.IDCardContainer.topAnchor, left: self.IDCardContainer.leftAnchor, bottom: self.IDCardContainer.bottomAnchor, right: self.IDCardContainer.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 0, height: 0)
            
            
        }) { (_) in
            self.view.addSubview(self.playAgainButton)
            self.playAgainButton.anchor(top: self.gameoverCard.bottomAnchor, left: self.gameoverCard.leftAnchor, bottom: nil, right: self.gameoverCard.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
            self.view.addSubview(self.quitToMenuButton)
            self.quitToMenuButton.anchor(top: self.playAgainButton.bottomAnchor, left: self.gameoverCard.leftAnchor, bottom: nil, right: self.gameoverCard.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        circleTimer.delegate = self
        
        highScore = defaults.object(forKey: highscoreKey) as? Int ?? 0
        
        setupLayout()
        personShadow.isHidden = true
        
        //        playMusic()
        
    }
    
    
    // MARK: - Layout
    
    fileprivate func setupLayout() {
        view.addSubview(backgroundImageView)
        
        tableImageView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height * 0.4)
        view.addSubview(tableImageView)
        view.addSubview(personShadow)
        view.addSubview(personImageView)
        view.addSubview(scoreLabel)
        view.addSubview(startButton)
        
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        personShadow.frame.size = CGSize(width: view.frame.width, height: 250)
        personShadow.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        personShadow.layer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.60)
        
        personImageView.frame.size = CGSize(width: 240 * 0.7, height: 400 * 0.7)
        personImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        personImageView.layer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.60)
        
        scoreLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(circleTimer)
        circleTimer.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 75, height: 75)
        circleTimer.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor).isActive = true
        circleTimer.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor, constant: -4).isActive = true
        
        view.addSubview(startButton)
        startButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width / 2, height: 60)
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        approveButton.frame.size = CGSize(width: 85, height: 85)
        denyButton.frame.size = CGSize(width: 85, height: 85)
        approveButton.center = CGPoint(x: self.view.center.x + view.center.x * 0.3, y: view.center.y * 1.86)
        denyButton.center = CGPoint(x: self.view.center.x - view.center.x * 0.3, y: view.center.y * 1.86)
        
        
        
        view.addSubview(approveButton)
        view.addSubview(denyButton)
        
        setupIDCard()

        
    }
    
    // MARK: - IDCard
    
    var IDCard: IDCardView = {
        let view = IDCardView()
        return view
    }()
    
    let IDCardContainer: IDCardContainerView = {
        let view = IDCardContainerView()
        return view
    }()
    
    // MARK: - Animations
    
    fileprivate func setupIDCard() {
        
        IDCardContainer.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 1.39)
        IDCardContainer.center.x -= view.bounds.width
        personImageView.center.x -= view.bounds.width
        
        view.addSubview(IDCardContainer)
    }
    
    
    fileprivate func slideInIDCardAndPerson() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.IDCardContainer.center.x = self.view.bounds.width / 2
        }) { (_) in
            // completion closure kept if needed in future
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.personImageView.center.x = self.view.bounds.width / 2
        }) { (_) in
            // completion closure kept if needed in future
            
        }
        
    }
    
    enum Direction {
        case right
        case left
    }
    
    fileprivate func slideOutIDCardAndPerson(_ direction: Direction) {
        if direction == .right {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.IDCardContainer.center.x = self.view.bounds.width * 2
                self.circleTimer.pause()
            }) { (_) in
                self.IDCardContainer.center.x = -self.view.bounds.width / 2
                
            }
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.personImageView.center.x = self.view.bounds.width * 2
            }) { (_) in
                self.personImageView.center.x = -self.view.bounds.width / 2
                self.selectRandomPerson()
                self.presentNextPerson()
            }
        } else {
            if direction == .left {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    self.IDCardContainer.center.x = -self.view.bounds.width / 2
                    self.circleTimer.pause()
                }) { (_) in
                    
                }
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    self.personImageView.center.x = -self.view.bounds.width / 2
                }) { (_) in
                    self.selectRandomPerson()
                    self.presentNextPerson()
                }
                
            }
        }
    }
    
    func flashRed() {
        let redBorderFlash = UIImageView(frame: view.frame)
        redBorderFlash.image = #imageLiteral(resourceName: "RedBorderFlash")
        redBorderFlash.alpha = 1
        redBorderFlash.layer.zPosition = 1200
        view.addSubview(redBorderFlash)
        
        
        personShadow.isHidden = false
        
        self.personShadow.alpha = 1
        UIView.animate(withDuration: 4, animations: {
            self.personShadow.alpha = 0
            redBorderFlash.alpha = 0
        }) { (_) in
            self.personShadow.isHidden = true
            redBorderFlash.removeFromSuperview()
        }
    }
    
    // MARK: - New Person Setup
    
    var randomPerson: Person?
    
    fileprivate func selectRandomPerson() {
        let genderProbability = arc4random_uniform(10) + 1
        
        
        let personDictionary = genderProbability >= 5 ? components.buildPerson(gender: .female) : components.buildPerson(gender: .male)
        
        let randomPerson = Person(personDictionary: personDictionary, gender: genderProbability >= 5 ? .female : .male)
        
        for (key, value) in randomPerson.avatarDictionary {
            personImageView.image = value
            personImageViewKey = key
        }
        
        let probabilityValue = arc4random_uniform(100) + 1
        if probabilityValue > 80 {
            personCanEnter = false
            
            let anotherGenderProbability = arc4random_uniform(10) + 1
            let anotherPersonDictionary = genderProbability >= 5 ? components.buildPerson(gender: .female) : components.buildPerson(gender: .male)
            let anotherRandomPerson = Person(personDictionary: anotherPersonDictionary, gender: anotherGenderProbability >= 5 ? .female : .male)
            IDCardContainer.person = anotherRandomPerson
        } else {
            IDCardContainer.person = randomPerson
        }
        
        checkIfPersonCanEnter(person: randomPerson)
    }
    
    var personCanEnter: Bool?
    
    fileprivate func checkIfPersonCanEnter(person: Person) {
        
        let currentTimestamp = Date().timeIntervalSince1970
        let expiryTimestamp = person.expiryDateTimeStamp
        
        if expiryTimestamp > currentTimestamp {
            isExpired = false
        } else if expiryTimestamp < currentTimestamp {
            isExpired = true
        }
        
        if person.age >= 19 {
            isLegal = true
        } else {
            isLegal = false
        }
    }
    
    // MARK: - Timer
    
    let circleTimer: SRCountdownTimer = {
        let timer = SRCountdownTimer()
        timer.backgroundColor = .clear
        timer.lineWidth = 5
        timer.lineColor = .white
        timer.isLabelHidden = true
        return timer
    }()
    
    func timerDidEnd() {
        gameover(for: .timerRanOutDuringPerson)
    }
}
