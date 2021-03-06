//
//  IDCardView.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-12.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

class IDCardView: UIView {

    func setupAttributedText(dob: String, expiry: String) {
		let attributedDobText = NSMutableAttributedString(string: "DOB:", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)])
		attributedDobText.append(NSAttributedString(string: " \(dob)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]))
        dobLabel.attributedText = attributedDobText
        
		let attributedExpiryString = NSMutableAttributedString(string: "EXPIRATION DATE\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 9)])
		attributedExpiryString.append(NSAttributedString(string: "\(expiry)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14.5)]))
        expiryLabel.attributedText = attributedExpiryString
    }
    
    var identificationImageKey: String?
    
    var identificationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "placeholder")
        iv.backgroundColor = UIColor(white: 0, alpha: 0.2)
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
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    override func layoutSubviews() {
        let stackView = UIStackView(arrangedSubviews: [identificationImageView, idBadgeImageView])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 40
        
        let textStackView = UIStackView(arrangedSubviews: [nameLabel, addressLabel, dobLabel])
        textStackView.axis = .vertical
        textStackView.distribution = .fillProportionally
        
        addSubview(stackView)
        addSubview(expiryLabel)
        addSubview(textStackView)
        
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 9, paddingBottom: 0, paddingRight: 9, width: 0, height: frame.height / 2)
        
        expiryLabel.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        textStackView.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
