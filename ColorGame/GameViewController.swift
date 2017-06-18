//
//  GameViewController.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-12.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    var highScore: Int = 0
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
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
        label.textColor = .white
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        return label
    }()
    
    var personImageKey: String?
    var personImage: UIImageView = {
        let iv = UIImageView()
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
        button.tag = 0
        return button
    }()
    
    let approveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "approve"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "BigRedButton").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleNextPerson), for: .touchUpInside)
        return button
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "background")
        return iv
    }()
    
    let tableImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "tableonly")
        return iv
    }()
    
    let thumbImageView: UIImageView = {
        let iv = UIImageView()
        iv.alpha = 0
        return iv
    }()
    
    let playAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:0.00, green:0.61, blue:1.00, alpha:0.9)
        button.layer.cornerRadius = 10
        button.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.zPosition = 1500
        button.addTarget(self, action: #selector(handlePlayAgain), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Action Selectors
    
    func handlePlayAgain() {
        gameoverCard.removeFromSuperview()
        playAgainButton.removeFromSuperview()
        self.unblur()
        self.score = 0
        self.selectRandomPerson()
        self.handleNextPerson()
    }
    
    func handleStart() {
        startButton.isHidden = true
        unhideApproveDenyButtons()
        slideInIDCardAndPerson()
        circleTimer.start(beginingValue: 3)
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
        
        if personImageKey == IDCardViewKey && isExpired == false && isLegal == true {
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
            slideOutIDCardAndPerson("right")
            
        }
        
        if isMatch == false && sender.tag == 0 {
            score += 1
            slideOutIDCardAndPerson("left")
            
        }
        
        if isMatch == false && sender.tag == 1 {
            if personImageKey != IDCardViewKey {
                gameover(for: .wrongID)
            }
            if isExpired == true {
                gameover(for: .expiredID)
            } else if isLegal == false {
                gameover(for: .underage)
            }
            flashRed()
        }
    }
    
    func handleNextPerson() {
        nextButton.isHidden = true
        unhideApproveDenyButtons()
        slideInIDCardAndPerson()
        circleTimer.start(beginingValue: 3)
        
    }
    
    // MARK: - Gameover
    let gameoverCard = GameoverView()
    fileprivate func gameover(for reason: GameoverReason) {
        circleTimer.pause()
        hideApproveDenyButtons()
        gameoverCard.layer.zPosition = 1500
        flashRed()
        
        if score > highScore {
            highScore = score
        }
        
        gameoverCard.reasonLabel.text = reason.rawValue
        gameoverCard.scoreLabel.text = "Score: \(score)"
        gameoverCard.highscoreLabel.text = "Highscore: \(highScore)"
        
        view.addSubview(gameoverCard)
        gameoverCard.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 200)
        gameoverCard.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        view.addSubview(playAgainButton)
        playAgainButton.anchor(top: gameoverCard.bottomAnchor, left: gameoverCard.leftAnchor, bottom: nil, right: gameoverCard.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        circleTimer.delegate = self
        
        hideApproveDenyButtons()
        fetchPeople()
        setupLayout()
        nextButton.isHidden = true
        personShadow.isHidden = true
        selectRandomPerson()
        //        playMusic()
        
    }
    
    // MARK: - Layout
    
    fileprivate func setupLayout() {
        view.addSubview(backgroundImageView)
        
        let buttonStackView = UIStackView(arrangedSubviews: [denyButton, approveButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 15
        buttonStackView.distribution = .fillEqually
        
        tableImageView.frame = CGRect(x: 0, y: view.bounds.height * 0.60, width: view.bounds.width, height: view.bounds.height * 0.40)
        view.addSubview(tableImageView)
        view.addSubview(personShadow)
        view.addSubview(personImage)
        view.addSubview(scoreLabel)
        view.addSubview(buttonStackView)
        view.addSubview(nextButton)
        view.addSubview(startButton)
        
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        personShadow.frame.size = CGSize(width: view.frame.width, height: 250)
        personShadow.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        personShadow.layer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height - tableImageView.frame.height)
        
        personImage.frame.size = CGSize(width: 250, height: 250)
        personImage.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        personImage.layer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height - tableImageView.frame.height)
        
        scoreLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(circleTimer)
        circleTimer.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 75, height: 75)
        circleTimer.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor).isActive = true
        circleTimer.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor).isActive = true
        
        buttonStackView.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 185, height: 85)
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        nextButton.anchor(top: nil, left: nil, bottom: buttonStackView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(startButton)
        startButton.anchor(top: nil, left: nil, bottom: tableImageView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: view.frame.width / 2, height: 60)
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
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
        personImage.center.x -= view.bounds.width
        
        view.addSubview(IDCardContainer)
    }
    
    fileprivate func slideInIDCardAndPerson() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.IDCardContainer.center.x = self.view.bounds.width / 2
        }) { (_) in
            // completion closure kept if needed in future
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.personImage.center.x = self.view.bounds.width / 2
        }) { (_) in
            // completion closure kept if needed in future
            
        }
        
    }
    
    fileprivate func slideOutIDCardAndPerson(_ direction: String) {
        if direction == "right" {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.IDCardContainer.center.x = self.view.bounds.width * 2
            }) { (_) in
                self.IDCardContainer.center.x = -self.view.bounds.width / 2
                
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.personImage.center.x = self.view.bounds.width * 2
            }) { (_) in
                self.personImage.center.x = -self.view.bounds.width / 2
                self.selectRandomPerson()
                self.nextButton.isHidden = false
            }
        } else {
            if direction == "left" {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    self.IDCardContainer.center.x = -self.view.bounds.width / 2
                }) { (_) in
                    
                }
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    self.personImage.center.x = -self.view.bounds.width / 2
                }) { (_) in
                    self.selectRandomPerson()
                    self.nextButton.isHidden = false
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
    
    // MARK: - JSON Serialization
    
    fileprivate func fetchPeople() {
        guard let path = Bundle.main.path(forResource: "People", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            guard let personDictionaries = json as? [[String: Any]] else { return }
            
            self.people = []
            for personDictionary in personDictionaries {
                let person = Person(jsonDictionary: personDictionary)
                self.people?.append(person)
            }
            
        } catch {
            print(error)
        }
    }
    
    // MARK: - New Person Setup
    
    var randomPerson: Person?
    
    fileprivate func selectRandomPerson() {
        
        guard let people = people else { return }
        var internalPersonArray = people
        // randomItem is a static func that picks a random element in an array.
        randomPerson = internalPersonArray.randomItem()
        guard let randomPerson = randomPerson else { return }
        let randomDob = components.dobs.randomItem()
        randomPerson.dobTest = randomDob
        
        for (key, value) in randomPerson.avatarDictionary {
            personImage.image = value
            personImageKey = key
        }
        
        let probabilityValue = arc4random_uniform(100) + 1
        if probabilityValue > 80 {
            personCanEnter = false
            
            if let index = internalPersonArray.index(of: randomPerson) {
                internalPersonArray.remove(at: index)
            }
            
            let anotherRandomPerson = internalPersonArray.randomItem()
            IDCardContainer.person = anotherRandomPerson
        } else {
            IDCardContainer.person = randomPerson
        }
        
        checkIfPersonCanEnter(person: randomPerson)
    }
    
    var personCanEnter: Bool?
    
    fileprivate func checkIfPersonCanEnter(person: Person) {
        
        guard let randomPerson = randomPerson else { return }
        
        let currentTimestamp = Date().timeIntervalSince1970
        let expiryTimestamp = randomPerson.expiryDateTimeStamp
        
        if expiryTimestamp > currentTimestamp {
            isExpired = false
        } else if expiryTimestamp < currentTimestamp {
            isExpired = true
        }
        
        if randomPerson.age >= 21 {
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
        
        if nextButton.isHidden == false {
            gameover(for: .timerRanOutDuringNext)
        } else {
            gameover(for: .timerRanOutDuringPerson)
        }
    }
}
