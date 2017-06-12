//
//  IDCardView.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-12.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

class IDCardView: UIView {
    
    var person: Person? {
        didSet {
            guard let person = person else { return }
            for (key, value) in person.avatarDictionary {
                identificationImageKey = key
                identificationImageView.image = value
            }
            
            nameLabel.text = "\(person.firstName) \(person.lastName)"
        }
    }
    
    var identificationImageKey: String?
    let identificationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "placeholder")
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Smith"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 5
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(identificationImageView)
        addSubview(nameLabel)
        
        identificationImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft:10, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        nameLabel.anchor(top: identificationImageView.topAnchor, left: identificationImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
