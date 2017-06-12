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
    
     let colorsArray: [UIColor] = [.cyan, .blue, .green, .magenta, .orange, .purple, .red, .yellow, .brown, .gray, UIColor.rgb(1, 0.65, 0.84), UIColor.rgb(0.46, 1, 0.15), UIColor.rgb(1, 0.85, 0.69), UIColor.rgb(0.33, 0.71, 0.61), UIColor.rgb(0.16, 0.17, 0.2), UIColor.rgb(0, 0.61, 1)]
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0 points"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var largeSquare: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var smallSquare: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    let doesMatchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("the two colors match", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        button.tag = 0
        return button
    }()

    
    let doesNotMatchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("the two colors do not\nmatch", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    
    func handleMatch(sender: UIButton!) {
        //doesMatchButton has a tag of 0 and doesNotMatchButton has a tag of 1
        var isMatch = Bool()
        if largeSquare.backgroundColor == smallSquare.backgroundColor {
            isMatch = true
        } else {
            isMatch = false
        }
        
        if isMatch == true && sender.tag == 0 {
            score += 1
            showAnswerAlertFor(correct: true)
        }
        
        if isMatch == true && sender.tag == 1 {
            score -= 1
            showAnswerAlertFor(correct: false)
        }
        
        if isMatch == false && sender.tag == 0 {
            score -= 1
            showAnswerAlertFor(correct: false)
        }
        
        if isMatch == false && sender.tag == 1 {
            score += 1
            showAnswerAlertFor(correct: true)
        }
    }
    
    func showAnswerAlertFor(correct: Bool) {
        var title = String()
        if correct == true {
            title = "Correct: Score + 1"
        } else if correct == false {
            title = "Incorrect: Score - 1"
        }
        let answerAlert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { (_) in
            self.score = 0
            self.setColors()
        }
        answerAlert.addAction(resetAction)

        let nextRoundAction = UIAlertAction(title: "Next Round", style: .default) { (_) in
            self.setColors()
        }
        answerAlert.addAction(nextRoundAction)
        
        present(answerAlert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [doesMatchButton, doesNotMatchButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(largeSquare)
        view.addSubview(smallSquare)
        view.addSubview(stackView)
        view.addSubview(containerView)
        view.addSubview(scoreLabel)

        setColors()
        
        // anchoring views using the anchoring extension in Extensions.swift
        largeSquare.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        largeSquare.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 70)
        
        containerView.anchor(top: nil, left: view.centerXAnchor, bottom: stackView.topAnchor, right: stackView.rightAnchor, paddingTop: 0, paddingLeft: -24, paddingBottom: 28, paddingRight: 0, width: 0, height: 140)
        
        smallSquare.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        scoreLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    // first make a copy of colorsArray so we can remove the random color selected for the large square. The color is removed because we handle the option that the colors match using a random number between 1 and 100. If the number less than 60, the smaller square is set to the same color as the large square (a match) and if the number is greater than 60, a random color is chosen from the 15 remaining colors in the array.
    
    func setColors() {
        var internalColorsArray = colorsArray
        
        // randomItem is a static func that picks a random element in an array.
        let randomColor = internalColorsArray.randomItem()
        largeSquare.backgroundColor = randomColor
        
    
            
        let value = arc4random_uniform(100) + 1
        print(value)
        if value > 60 {
            // since the number is greater than 60, the colors are not going to be a match, therefore we need to remove the color of the large square from the array so we don't get a match
            
            if let index = internalColorsArray.index(of: randomColor) {
                internalColorsArray.remove(at: index)
            }
            smallSquare.backgroundColor = internalColorsArray.randomItem()
        } else {
            smallSquare.backgroundColor = randomColor
        }
    }
}
