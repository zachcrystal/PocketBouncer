//
//  ViewController.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-11.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit
import Macaw

class ViewController: UIViewController {
    
    var people: [Person]?
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var exponentialMessUp: Int = 1
    
    var countdown = 30
    
    var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0 points"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "30"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    var personImageKey: String?
    var personImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "placeholder")
        return iv
    }()
    
    let IDCard: IDCardView = {
        let view = IDCardView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    let getLostButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Get lost!", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        button.tag = 0
        return button
    }()
    
    let comeOnInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Thanks, come on in", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    
    
    
    
    func handleMatch(sender: UIButton!) {
        // getLost tag = 0, comeOnIn tag = 1
        print(sender.tag)
//        let IDCard = IDCardView()
        
        var isMatch = Bool()
        guard let IDCardViewKey = IDCard.identificationImageKey else { return }
        
        if personImageKey == IDCardViewKey {
            isMatch = true
        } else {
            isMatch = false
        }
        
        
        if isMatch == true && sender.tag == 0 {
            score -= 10 * exponentialMessUp
            showIncorrectResponseAlert(getLost: true)
            exponentialMessUp *= 2
        }
        
        if (isMatch == true && sender.tag == 1) || (isMatch == false && sender.tag == 0)  {
            score += 1
            selectRandomPerson()
        }
        
        if isMatch == false && sender.tag == 1 {
            score -= 10 * exponentialMessUp
            showIncorrectResponseAlert(getLost: false)
            exponentialMessUp *= 2
        }
    }
    
    func showIncorrectResponseAlert(getLost: Bool) {
        
        let getLostTitle = "Hey! What did you do that for?! You're costing us money!"
        let wrongLetInTitle = "Hey! You let someone in you weren't supposed to!"
        let message = "Incorrect: Score - \(10 * exponentialMessUp)"
        let answerAlert = UIAlertController(title: getLost ? getLostTitle : wrongLetInTitle, message: message, preferredStyle: .alert)
        let nextRoundAction = UIAlertAction(title: "Sorry! It won't happen again!", style: .default) { (_) in
            self.selectRandomPerson()
        }
        answerAlert.addAction(nextRoundAction)
        
        present(answerAlert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        fetchPeople()
        
        let stackView = UIStackView(arrangedSubviews: [getLostButton, comeOnInButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(personImage)
        view.addSubview(stackView)
        view.addSubview(IDCard)
        view.addSubview(scoreLabel)
        view.addSubview(timerLabel)
        
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        selectRandomPerson()
        
        // anchoring views using the anchoring extension in Extensions.swift
        personImage.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 140, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
        personImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 70)
        
        IDCard.anchor(top: nil, left: view.centerXAnchor, bottom: stackView.topAnchor, right: stackView.rightAnchor, paddingTop: 0, paddingLeft: -24, paddingBottom: 28, paddingRight: 0, width: 0, height: 140)
        
        scoreLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        timerLabel.anchor(top: nil, left: nil, bottom: personImage.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 0, height: 30)
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    func fetchPeople() {
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
    
    
    func updateCounter() {
        if countdown > 0 {
            countdown -= 1
            timerLabel.text = "\(countdown)"
        }
    }
    

    // first make a copy of people array so we can remove the random person selected for the large square. The person is removed because we handle the option that the people match using a random number between 1 and 100. If the number less than 80, the smaller square is set to the same color as the large square (a match) and if the number is greater than 60, a random color is chosen from the 15 remaining colors in the array.
   
    
    func selectRandomPerson() {

        guard let people = people else { return }
        var internalPersonArray = people
        // randomItem is a static func that picks a random element in an array.
        let randomPerson = internalPersonArray.randomItem()
        for (key, value) in randomPerson.avatarDictionary {
            personImage.image = value
            personImageKey = key
        }
        
        let value = arc4random_uniform(100) + 1
        print(value)
        if value > 80 {
            // since the number is greater than 60, the colors are not going to be a match, therefore we need to remove the color of the large square from the array so we don't get a match
            
            if let index = internalPersonArray.index(of: randomPerson) {
                internalPersonArray.remove(at: index)
            }
            
            let anotherRandomPerson = internalPersonArray.randomItem()
            IDCard.person = anotherRandomPerson
        } else {
            IDCard.person = randomPerson
        }
    }
    
    func image(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
        let data1: NSData = UIImagePNGRepresentation(image1)! as NSData
        let data2: NSData = UIImagePNGRepresentation(image2)! as NSData
        return data1.isEqual(data2)
    }
}

