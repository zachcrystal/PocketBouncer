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
        }
    }
    
    var identificationImageKey: String?
    let identificationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "placeholder")
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 5
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(identificationImageView)
        
        identificationImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft:10, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
