//
//  GameViewController.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-12.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

/* 
 TODO: Swiping
 - make the entire screen swipeable but only move the person and the card... 
 - it won't call the slide out method, but it will call the slide in method
 */

import UIKit
import AVFoundation

class GameViewController: UIViewController, SRCountdownTimerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Isolated Properties
    
    var people: [Person]?
    
    var idIsExpired: Bool?
    var legalAge: Bool?
    
    var highScore: Int = 0
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    // MARK: - UIKit Components
    
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
    
    
    let denyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "deny"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        button.tag = 0
        button.adjustsImageWhenDisabled = true
        button.isUserInteractionEnabled = false
        button.isEnabled = false
        return button
    }()
    
    let approveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "approve"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        button.tag = 1
        button.adjustsImageWhenDisabled = true
        button.isUserInteractionEnabled = false
        button.isEnabled = false
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "next"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleNextPerson), for: .touchUpInside)
        button.adjustsImageWhenDisabled = true
        button.isUserInteractionEnabled = false
        button.isEnabled = false
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
    
    // MARK: - Action Selectors
    
    func handleMatch(sender: UIButton!) {
        approveButton.isEnabled = false
        denyButton.isEnabled = false
        approveButton.isUserInteractionEnabled = false
        denyButton.isEnabled = false
        // deny tag = 0, approve tag = 1
        
        var isMatch = Bool()
        guard let IDCardViewKey = IDCardContainer.IDCard.identificationImageKey else { return }
        
        if personImageKey == IDCardViewKey && idIsExpired == false && legalAge == true {
            isMatch = true
        } else {
            isMatch = false
        }
        
        if isMatch == true && sender.tag == 0 {
            showIncorrectResponseAlert(getLost: true)
            slideOutIDCardAndPerson()
        }
        
        if isMatch == true && sender.tag == 1  {
            score += 1
            slideOutIDCardAndPerson()
            
        }
        
        if isMatch == false && sender.tag == 0 {
            score += 1
            slideOutIDCardAndPerson()
            
        }
        
        if isMatch == false && sender.tag == 1 {
            showIncorrectResponseAlert(getLost: false)
            slideOutIDCardAndPerson()
            
        }
    }
    
    func handleNextPerson() {
        slideInIDCardAndPerson()
        circleTimer.start(beginingValue: 3)
        
    }
    
    var IDCardCenter: CGPoint?
    var personImageCenter: CGPoint?
    
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        guard let IDCardContainerViewCenter = IDCardCenter else { return }
        guard let personImageCenter = personImageCenter else { return }
        let point = sender.translation(in: view)
        IDCardContainer.center = CGPoint(x: IDCardContainerViewCenter.x + point.x, y: IDCardContainerViewCenter.y)
        personImage.center = CGPoint(x: personImageCenter.x + point.x, y: personImageCenter.y)
        
        if sender.state == UIGestureRecognizerState.ended {
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.IDCardContainer.center = IDCardContainerViewCenter
                self.personImage.center = personImageCenter
            }
        }
    }

    // MARK: - Alert Controller
    
    fileprivate func showIncorrectResponseAlert(getLost: Bool, timerDidRunOut: Bool = false) {
        if timerDidRunOut == false {
            circleTimer.pause()
        }
        
        if score > highScore {
            highScore = score
        }
        
        let getLostTitle = "Hey! What did you do that for?! You're costing us money!"
        let wrongLetInTitle = "Hey! You let someone in you weren't supposed to!"
        let message = "Score: \(score)\nPersonal Best: \(highScore)"
        let answerAlert = UIAlertController(title: getLost ? getLostTitle : wrongLetInTitle, message: message, preferredStyle: .alert)
        let nextRoundAction = UIAlertAction(title: "Sorry! It won't happen again!", style: .default) { (_) in
            self.score = 0
            self.selectRandomPerson()
            self.handleNextPerson()
            
            
        }
        answerAlert.addAction(nextRoundAction)
        
        present(answerAlert, animated: true, completion: nil)
        
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        circleTimer.delegate = self
        
        fetchPeople()
        
        setupLayout()
        
        selectRandomPerson()
        slideInIDCardAndPerson()
        //        playMusic()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IDCardCenter = IDCardContainer.center
        personImageCenter = personImage.center
    }

    // MARK: - Layout
    
    fileprivate func setupLayout() {
        view.addSubview(backgroundImageView)
        
        tableImageView.frame = CGRect(x: 0, y: view.bounds.height * 0.60, width: view.bounds.width, height: view.bounds.height * 0.40)
        view.addSubview(tableImageView)
        view.addSubview(nextButton)
        view.addSubview(personImage)
        view.addSubview(approveButton)
        view.addSubview(denyButton)
        view.addSubview(scoreLabel)
        
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        personImage.frame.size = CGSize(width: 250, height: 250)
        personImage.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        personImage.layer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height - tableImageView.frame.height)
        
        nextButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 45, paddingRight: 0, width: 50, height: 50)
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        denyButton.anchor(top: nextButton.topAnchor, left: nil, bottom: view.bottomAnchor, right: nextButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: -4, width: 90, height: 0)
        
        approveButton.anchor(top: nextButton.topAnchor, left: nextButton.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: -4, paddingBottom: 4, paddingRight: 0, width: 90, height: 0)
        
        
        scoreLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(circleTimer)
        circleTimer.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 75, height: 75)
        circleTimer.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor).isActive = true
        circleTimer.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor).isActive = true

        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
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
    
    fileprivate func setupIDCard() {
        
        IDCardContainer.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 1.39)
        IDCardContainer.center.x -= view.bounds.width
        personImage.center.x -= view.bounds.width
        
        view.addSubview(IDCardContainer)
        
//        IDCardContainer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
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
            self.removeNextAndEnableButtons()
            
        }
        
    }
    
    fileprivate func slideOutIDCardAndPerson() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.IDCardContainer.center.x += self.view.bounds.width
        }) { (_) in
            self.IDCardContainer.center.x = -self.view.bounds.width / 2
            
        }
        //        personImage.center.x = self.view.bounds.width / 2
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.personImage.center.x += self.view.bounds.width
        }) { (_) in
            self.personImage.center.x = -self.view.bounds.width / 2
            self.selectRandomPerson()
            self.setupNextButtonAndDisableButtons()
        }
        
    }
    
    // MARK: - Buttons
    
    func setupNextButtonAndDisableButtons() {
        nextButton.isEnabled = true
        nextButton.isUserInteractionEnabled = true
    }
    
    func removeNextAndEnableButtons() {
        nextButton.isEnabled = false
        nextButton.isUserInteractionEnabled = false
        approveButton.isEnabled = true
        approveButton.isUserInteractionEnabled = true
        denyButton.isEnabled = true
        denyButton.isUserInteractionEnabled = true
        
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
        
        for (key, value) in randomPerson.avatarDictionary {
            personImage.image = value
            personImageKey = key
        }
        
        let probabilityValue = arc4random_uniform(100) + 1
        if probabilityValue > 80 {
            
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
    
    fileprivate func checkIfPersonCanEnter(person: Person) {
        
        guard let randomPerson = randomPerson else { return }
        
        let currentTimestamp = Date().timeIntervalSince1970
        let expiryTimestamp = randomPerson.expiryDateTimeStamp
        
        if expiryTimestamp > currentTimestamp {
            idIsExpired = false
        } else if expiryTimestamp < currentTimestamp {
            idIsExpired = true
        }
        
        if randomPerson.age >= 21 {
            legalAge = true
        } else {
            legalAge = false
        }
    }
    
    // MARK: - Timer
    
    let circleTimer: SRCountdownTimer = {
        let timer = SRCountdownTimer()
        timer.start(beginingValue: 4)
        timer.backgroundColor = .clear
        timer.lineWidth = 5
        timer.lineColor = .white
        return timer
    }()
    
    
    func timerDidEnd() {
        showIncorrectResponseAlert(getLost: true, timerDidRunOut: true)
    }
}
