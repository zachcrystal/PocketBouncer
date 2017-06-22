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
    
    // MARK: Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Components Singleton
    let components = Components.sharedComponentsData
    
    
    // MARK: - Match Variables
    var isSamePerson: Bool?
    var isExpired: Bool?
    var isLegal: Bool?
    
    
    let defaults = UserDefaults.standard // User Defaults for storing highscore
    let highscoreKey = "highscore" // key for storing and retrieving highscore from user defaults
    
    var level: Int = 1
    
    var highScore: Int = 0
    
    var score: Int = 0 {
        didSet {
            let attributedScoreText = NSMutableAttributedString(string: "SCORE", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 10)])
            attributedScoreText.append(NSAttributedString(string: "\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 2)]))
            attributedScoreText.append(NSAttributedString(string: "\(score)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 34)]))
            scoreLabel.attributedText = attributedScoreText
            if score == 10 {
                level = 2
                rulesLabel.text?.append("\nNo Sunglasses")
            }
            if score == 15 {
                level = 3
                rulesLabel.text?.append("\nNo Hats")
            }
            if score == 20 {
                level = 4
            }
        }
    }
    
    // MARK: - UIKit Components
    var rulesLabel: UILabel = {
        let label = UILabel()
        label.text = "Rules:\n19+"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 3
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
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
    
    // function animates everything off screen and removes gameover buttons from the superview for a clean slate. Not fully clean though, because the people and IDCard arent removed from the superview, they are just placed to the left for when they are called to slide in.
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
            // left completion block if needed
        }

        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.tableImageView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height * 0.4)
        }) { (_) in
            // left completion block if needed
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.6, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
            self.denyButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
            self.denyButton.isHidden = true
        }) { (_) in
            self.putIDCardDown()
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.8, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
            self.approveButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
            self.approveButton.isHidden = true
        }) { (_) in
            self.startButton.isHidden = false
        }
    }
    
    // function removes gameover labels, animates in the table and buttons, sets the ID Card down and slides in both the person and the ID Card
    func handleStart() {
        gameoverCard.removeFromSuperview()
        playAgainButton.removeFromSuperview()
        quitToMenuButton.removeFromSuperview()
        score = 0
        selectRandomPerson()
        startButton.isHidden = true
        self.denyButton.isHidden = true
        self.approveButton.isHidden = true
        
        // the buttons don't pop in at different times, not sure why...
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.tableImageView.frame = CGRect(x: 0, y: self.view.bounds.height * 0.60, width: self.view.bounds.width, height: self.view.bounds.height * 0.4)
        }) { (_) in
            // left completion if needed
        }
        
        self.denyButton.isHidden = false
        denyButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
        UIView.animate(withDuration: 1.0, delay: 0.4, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
            
            self.denyButton.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        }) { (_) in
            // left completion if needed
        }
        
        self.approveButton.isHidden = false
        approveButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
        UIView.animate(withDuration: 1.0, delay: 0.8, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
            self.approveButton.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }) { (_) in
            self.presentNextPerson()
            if self.level >= 4 {
                self.circleTimer.start(beginningValue: 4)
            } else {
                self.circleTimer.start(beginningValue: 5)
            }
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
        
        if personImageViewKey == IDCardViewKey && isExpired == false && isLegal == true, isWearingSunglasses == false, isWearingHat == false {
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
            
            if isWearingSunglasses == true {
                gameover(for: .isWearingSunglasses)
                flashRed()
                return
            }
            
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
    
    // presents next person, should figure out if I'm accidentally calling methods twice by introducing this function.
    func presentNextPerson() {
        unhideApproveDenyButtons()
        slideInIDCardAndPerson()
        if level >= 4 {
            circleTimer.start(beginningValue: 4)
        } else {
        circleTimer.start(beginningValue: 5)
        }
    }
    
    // MARK: - Gameover
    
    // instantiate the gameoverCard. Method for gameover includes pausing the timer, hiding the buttons, a vibration, and a red flash. In addition, there is a highscore check, the card "unperspective" animation, and the addition of the playAgainButton and the quitToMenuButton.
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
        
        if locale == "US" {
            rulesLabel.text = "Rules:\n21+"
        } else if locale == "CA" {
            rulesLabel.text = "Rules:\n19+"
        } else {
            rulesLabel.text = "Rules:\n21+"
        }
    }
    
    // MARK: - Layout
    
    fileprivate func setupLayout() {
        view.addSubview(backgroundImageView)
        
        tableImageView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height * 0.4)
        view.addSubview(tableImageView)
        view.addSubview(personImageView)
        view.addSubview(scoreLabel)
        view.addSubview(startButton)
        
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        backgroundImageView.addSubview(rulesLabel)
        
        rulesLabel.anchor(top: backgroundImageView.topAnchor, left: backgroundImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: view.frame.width / 3, height: view.frame.height / 5)
        rulesLabel.alpha = 0.6
        
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
        
        UIView.animate(withDuration: 4, animations: {
            redBorderFlash.alpha = 0
        }) { (_) in
            redBorderFlash.removeFromSuperview()
        }
    }
    
    // MARK: - New Person Setup
    var randomPerson: Person?
    var isWearingSunglasses = false
    var isWearingHat = false
    
    fileprivate func selectRandomPerson() {
        let genderProbability = arc4random_uniform(10) + 1
        
        let personDictionary = genderProbability >= 5 ? components.buildPerson(gender: .female) : components.buildPerson(gender: .male)
        
        let randomPerson = Person(personDictionary: personDictionary, gender: genderProbability >= 5 ? .female : .male, level: level)
        isWearingSunglasses = randomPerson.isWearingSunglasses
        isWearingHat = randomPerson.isWearingHat
        
        for (key, value) in randomPerson.avatarDictionary {
            personImageView.image = value
            personImageViewKey = key
        }
        
        let probabilityValue = arc4random_uniform(100) + 1
        if probabilityValue > 80 {
            personCanEnter = false
            
            let anotherGenderProbability = arc4random_uniform(10) + 1
            let anotherPersonDictionary = genderProbability >= 5 ? components.buildPerson(gender: .female) : components.buildPerson(gender: .male)
            let anotherRandomPerson = Person(personDictionary: anotherPersonDictionary, gender: anotherGenderProbability >= 5 ? .female : .male, level: level)
            IDCardContainer.person = anotherRandomPerson
        } else {
            IDCardContainer.person = randomPerson
        }
        
        checkIfPersonCanEnter(person: randomPerson)
    }
    
    var personCanEnter: Bool?
    let locale = Locale.current.regionCode
    
    fileprivate func checkIfPersonCanEnter(person: Person) {
        
        let currentTimestamp = Date().timeIntervalSince1970
        let expiryTimestamp = person.expiryDateTimeStamp
        
        if expiryTimestamp > currentTimestamp {
            isExpired = false
        } else if expiryTimestamp < currentTimestamp {
            isExpired = true
        }
        
        // USA and Canada localization... quebec?... if I added localization by province, I'd have to make the locale auto-update I think. I have to look into whether province localization is even possible. I may have to go by language in Canada, "en-CA" and fr-CA" to determine legal drinking age.
        if locale == "US" {
            if person.age >= 21 {
                isLegal = true
            } else {
                isLegal = false
            }
        } else if locale == "CA" {
            if person.age >= 19 {
                isLegal = true
            } else {
                isLegal = false
            }
        } else {
            if person.age >= 21 {
                isLegal = true
            } else {
                isLegal = false
            }
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
