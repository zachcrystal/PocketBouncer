//
//  ViewController.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-11.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 16 colors
    
//     let colorsArray: [UIColor] = [.cyan, .blue, .green, .magenta, .orange, .purple, .red, .yellow, .brown, .gray, UIColor.rgb(1, 0.65, 0.84), UIColor.rgb(0.46, 1, 0.15), UIColor.rgb(1, 0.85, 0.69), UIColor.rgb(0.33, 0.71, 0.61), UIColor.rgb(0.16, 0.17, 0.2), UIColor.rgb(0, 0.61, 1)]
    
    let imageArray: [UIImage] = [#imageLiteral(resourceName: "image1"), #imageLiteral(resourceName: "image2"), #imageLiteral(resourceName: "image3"), #imageLiteral(resourceName: "image4"), #imageLiteral(resourceName: "image5")]
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var countdown = 30
    
    var exponentialMessUp: Int = 1
    
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

    
    var largeSquare: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "placeholder")
        return iv
    }()
    
    var smallSquare: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "placeholder")
        return iv
    }()
    
    let containerView: UIView = {
        let view = UIView()
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
        var isMatch = Bool()
        if largeSquare.image == smallSquare.image {
            isMatch = true
        } else {
            isMatch = false
        }
        
        if isMatch == true && sender.tag == 0 {
            score -= 10 * exponentialMessUp
            showIncorrectAnswerAlert(getLost: true)
            exponentialMessUp *= 2
        }
        
        if (isMatch == true && sender.tag == 1) || (isMatch == false && sender.tag == 0)  {
            score += 1
            setImages()
        }
        
        if isMatch == false && sender.tag == 1 {
            score -= 10 * exponentialMessUp
            showIncorrectAnswerAlert(getLost: false)
            exponentialMessUp *= 2
        }
    }
    
    func showIncorrectAnswerAlert(getLost: Bool) {

        let getLostTitle = "Hey! What did you do that for?! You're costing us money!"
        let wrongLetInTitle = "Hey! You let someone in you weren't supposed to!"
        let message = "Incorrect: Score - \(10 * exponentialMessUp)"
        let answerAlert = UIAlertController(title: getLost ? getLostTitle : wrongLetInTitle, message: message, preferredStyle: .alert)
        let nextRoundAction = UIAlertAction(title: "Sorry! It won't happen again!", style: .default) { (_) in
            self.setImages()
        }
        answerAlert.addAction(nextRoundAction)
        
        present(answerAlert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [getLostButton, comeOnInButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(largeSquare)
        view.addSubview(smallSquare)
        view.addSubview(stackView)
        view.addSubview(containerView)
        view.addSubview(scoreLabel)
        view.addSubview(timerLabel)
        
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

        

        setImages()
        
        // anchoring views using the anchoring extension in Extensions.swift
        largeSquare.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 140, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
        largeSquare.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 70)
        
        containerView.anchor(top: nil, left: view.centerXAnchor, bottom: stackView.topAnchor, right: stackView.rightAnchor, paddingTop: 0, paddingLeft: -24, paddingBottom: 28, paddingRight: 0, width: 0, height: 140)
        
        smallSquare.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        scoreLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        timerLabel.anchor(top: nil, left: nil, bottom: largeSquare.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 0, height: 30)
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    func updateCounter() {
        //you code, this is an example
        if countdown > 0 {
            countdown -= 1
            timerLabel.text = "\(countdown)"
        }
    }
    
    
    
    // first make a copy of colorsArray so we can remove the random color selected for the large square. The color is removed because we handle the option that the colors match using a random number between 1 and 100. If the number less than 60, the smaller square is set to the same color as the large square (a match) and if the number is greater than 60, a random color is chosen from the 15 remaining colors in the array.
    
    func setImages() {
        var internalImageArray = imageArray
        
        // randomItem is a static func that picks a random element in an array.
        let randomImage = internalImageArray.randomItem()
        largeSquare.image = randomImage
        
    
            
        let value = arc4random_uniform(100) + 1
        print(value)
        if value > 60 {
            // since the number is greater than 60, the colors are not going to be a match, therefore we need to remove the color of the large square from the array so we don't get a match
            
            if let index = internalImageArray.index(of: randomImage) {
                internalImageArray.remove(at: index)
            }
            smallSquare.image = internalImageArray.randomItem()
        } else {
            smallSquare.image = randomImage
        }
    }
}
