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
            expiryLabel.text = "EXPIRATION DATE\n\(person.expiryDateString)"
            addressLabel.text = person.address
            idBadgeImageView.image = person.idBadge
            setupAttributedText()
            
        }
    }
    
    func setupAttributedText() {
        guard let person = person else { return }
        let attributedDobText = NSMutableAttributedString(string: "DOB:", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)])
        attributedDobText.append(NSAttributedString(string: " \(person.dob)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]))
        dobLabel.attributedText = attributedDobText
        
        let attributedExpiryString = NSMutableAttributedString(string: "EXPIRATION DATE\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 9)])
        attributedExpiryString.append(NSAttributedString(string: "\(person.expiryDateString)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.5)]))
        expiryLabel.attributedText = attributedExpiryString
    }
    
    
    var identificationImageKey: String?
    
    let identificationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "placeholder")
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let idBadgeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "placeholder")
        iv.backgroundColor = .clear
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Smith"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var dobLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let expiryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .justified
        label.numberOfLines = 2
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "123 Fake Street"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let stackView = UIStackView(arrangedSubviews: [identificationImageView, idBadgeImageView])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        let textStackView = UIStackView(arrangedSubviews: [nameLabel, addressLabel, dobLabel])
        textStackView.axis = .vertical
        
        addSubview(stackView)
        addSubview(expiryLabel)
//        addSubview(nameLabel)
//        addSubview(addressLabel)
//        addSubview(dobLabel)
        addSubview(textStackView)
        
        
        // total height is 180
        
        
        // 120 with padding
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 9, paddingBottom: 0, paddingRight: 9, width: 0, height: (240 / 2) - 16)
        
        expiryLabel.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        
        textStackView.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        
       
//        nameLabel.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
//        
//        addressLabel.anchor(top: nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nameLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        
//        dobLabel.anchor(top: addressLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nameLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
