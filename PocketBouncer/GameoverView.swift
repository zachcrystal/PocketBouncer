//
//  GameoverView.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-17.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

class GameoverView: UIView {
    
    var gameoverLabel: UILabel = {
        let label = UILabel()
        label.text = "Gameover"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightBlack)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
        
    var reasonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var highscoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {

        let scoreStackview = UIStackView(arrangedSubviews: [scoreLabel, highscoreLabel])
        scoreStackview.axis = .vertical
        scoreStackview.distribution = .fillEqually
        scoreStackview.alignment = .center
        scoreStackview.spacing = 4
        
        let stackView = UIStackView(arrangedSubviews: [gameoverLabel, reasonLabel, scoreStackview])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        addSubview(stackView)
        
//        gameoverLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
//        
//        reasonLabel.anchor(top: gameoverLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: frame.height / 3)
//        
//        scoreStackview.anchor(top: reasonLabel.bottomAnchor, left: reasonLabel.leftAnchor, bottom: bottomAnchor, right: reasonLabel.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 4, paddingRight: 10, width: 0, height: 0)

    }
}
