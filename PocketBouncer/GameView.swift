//
//  GameView.swift
//  PocketBouncer
//
//  Created by Zach Crystal on 2017-06-30.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    var delegate: GameViewDelegate?
    
    let circleTimer: SRCountdownTimer = {
        let timer = SRCountdownTimer()
        timer.backgroundColor = .clear
        timer.lineWidth = 5
        timer.lineColor = .white
        timer.isLabelHidden = true
        return timer
    }()

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
    
    func handleStart() {
        delegate?.didTapStart()
    }
    
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
    
    let denyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "deny"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleDidTapDeny), for: .touchUpInside)
        button.isHidden = true
        button.tag = 0
        return button
    }()
    
    func handleDidTapDeny() {
        delegate?.didTapDeny()
    }
    
    let approveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "approve"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleDidTapApprove), for: .touchUpInside)
        button.isHidden = true
        button.tag = 1
        return button
    }()
    
    func handleDidTapApprove() {
        delegate?.didTapApprove()
    }
    
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
    
    func handlePlayAgain() {
        delegate?.didTapTryAgain()
    }
    
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
        button.addTarget(self, action: #selector(handleMainMenu), for: .touchUpInside)
        return button
    }()

    func handleMainMenu() {
        delegate?.didTapQuitToMenu()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(backgroundImageView)
        
        tableImageView.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: bounds.height * 0.4)
        addSubview(tableImageView)
        
        addSubview(scoreLabel)
        addSubview(startButton)
        
        backgroundImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        backgroundImageView.addSubview(rulesLabel)
        
        rulesLabel.anchor(top: backgroundImageView.topAnchor, left: backgroundImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 120, height: 100)
        rulesLabel.alpha = 0.6

        
        scoreLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(circleTimer)
        circleTimer.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 75, height: 75)
        circleTimer.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor).isActive = true
        circleTimer.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor, constant: -4).isActive = true
        
        addSubview(startButton)
        startButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 60)
        startButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        

        addSubview(approveButton)
        addSubview(denyButton)
        
        approveButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 50).isActive = true
        approveButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 80, height: 80)
        
        denyButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -50).isActive = true
        denyButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 80, height: 80)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
