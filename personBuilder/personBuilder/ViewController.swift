//
//  ViewController.swift
//  personBuilder
//
//  Created by Zach Crystal on 2017-06-19.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.frame.size = CGSize(width: 240, height: 400)
        imageView.center = view.center
        view.addSubview(imageView)
        
        let center = imageView.bounds.width / 2
        let backImageView = UIImageView(image: #imageLiteral(resourceName: "BackTest"))
        backImageView.tintColor = .blue
        backImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        backImageView.layer.position = CGPoint(x: center, y: imageView.bounds.height)
        backImageView.layer.zPosition = 0
        imageView.addSubview(backImageView)
//        
//        let faceImageView = UIImageView(image: #imageLiteral(resourceName: "PeachFace"))
//        faceImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
//        faceImageView.layer.position = CGPoint(x: center, y: imageView.bounds.height - backImageView.bounds.height * 0.675)
//        faceImageView.layer.zPosition = 1
//        imageView.addSubview(faceImageView)
//        
//        let eyesImageView = UIImageView(image: #imageLiteral(resourceName: "NormalEyes"))
//        eyesImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
//        eyesImageView.layer.position = CGPoint(x: faceImageView.bounds.width / 2, y: imageView.bounds.height * 0.25)
//        eyesImageView.layer.zPosition = 1
//        faceImageView.addSubview(eyesImageView)
        
//        let mouthImageView = UIImageView(image: #imageLiteral(resourceName: "HappySmallWhite"))
//        mouthImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        mouthImageView.layer.position = CGPoint(x: faceImageView.bounds.width / 2, y: faceImageView.bounds.height * 0.70)
//        mouthImageView.layer.zPosition = 1
//        faceImageView.addSubview(mouthImageView)


        
    }

}

