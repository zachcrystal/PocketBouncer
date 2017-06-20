//
//  AvatarBuilder.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-19.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

class AvatarBuilder {
    
    static let avatarBuilder = AvatarBuilder()
    
    var skinColours: [UIImage] = [#imageLiteral(resourceName: "PeachFace"), #imageLiteral(resourceName: "BeigeFace"), #imageLiteral(resourceName: "BrownFace")]
    var noses: [UIImage] = [#imageLiteral(resourceName: "WideNose"), #imageLiteral(resourceName: "NormalNose"), #imageLiteral(resourceName: "RoundNose")]
    var eyeColours: [UIColor] = [UIColor(red:0.28, green:0.59, blue:0.61, alpha:1.00), UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00), UIColor(red:0.31, green:0.65, blue:0.24, alpha:1.00), UIColor(red:0.54, green:0.42, blue:0.20, alpha:1.00)]
    var eyes: [UIImage] = [#imageLiteral(resourceName: "NormalEyes"), #imageLiteral(resourceName: "HappyEyes"), #imageLiteral(resourceName: "DownEyes")]
    var shirtStripes = [nil, #imageLiteral(resourceName: "StripesHorz"), #imageLiteral(resourceName: "StripesVert"), #imageLiteral(resourceName: "Lapels")]
    var mouths: [UIImage] = [#imageLiteral(resourceName: "Round"), #imageLiteral(resourceName: "SmallTongue"), #imageLiteral(resourceName: "HappySmallWhite"), #imageLiteral(resourceName: "Singing"), #imageLiteral(resourceName: "Closed"), #imageLiteral(resourceName: "HappySmallBlack")]
    var colourPaletes: [[String: UIColor]] = [["Dark": UIColor(red:0.19, green:0.19, blue:0.19, alpha:1.00), "Light": UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.00)], ["Dark": UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.00), "Light": UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.00)], ["Dark": UIColor(red:0.60, green:0.17, blue:0.14, alpha:1.00), "Light": UIColor(red:0.77, green:0.26, blue:0.23, alpha:1.00)], ["Dark": UIColor(red:0.72, green:0.48, blue:0.19, alpha:1.00), "Light": UIColor(red:0.84, green:0.60, blue:0.30, alpha:1.00)], ["Dark": UIColor(red:0.82, green:0.76, blue:0.26, alpha:1.00), "Light": UIColor(red:0.91, green:0.87, blue:0.39, alpha:1.00)], ["Dark": UIColor(red:0.30, green:0.62, blue:0.23, alpha:1.00), "Light": UIColor(red:0.38, green:0.77, blue:0.30, alpha:1.00)], ["Dark": UIColor(red:0.15, green:0.23, blue:0.60, alpha:1.00), "Light": UIColor(red:0.25, green:0.34, blue:0.77, alpha:1.00)], ["Dark": UIColor(red:0.40, green:0.18, blue:0.52, alpha:1.00), "Light": UIColor(red:0.49, green:0.29, blue:0.62, alpha:1.00)], ["Dark": UIColor(red:0.56, green:0.18, blue:0.39, alpha:1.00), "Light": UIColor(red:0.73, green:0.27, blue:0.53, alpha:1.00)]]
    var maleHairBack: [UIImage] = [#imageLiteral(resourceName: "Short")]
    var maleHairFront: [UIImage] = [#imageLiteral(resourceName: "LongFringeChip"), #imageLiteral(resourceName: "Tuft"), #imageLiteral(resourceName: "Bobble")]
    var facialHair = [nil, #imageLiteral(resourceName: "BeardSmall")]
    var femaleHairBack: [UIImage] = [#imageLiteral(resourceName: "Long")]
    var femaleHairFront: [UIImage] = [#imageLiteral(resourceName: "LongFringe"), #imageLiteral(resourceName: "Tuft")]
    var hairColours: [UIColor] = [UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.00), UIColor(red:0.54, green:0.46, blue:0.29, alpha:1.00), UIColor(red:0.95, green:0.91, blue:0.41, alpha:1.00), UIColor(red:0.89, green:0.64, blue:0.31, alpha:1.00), UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)]
    
    // Layer Positions
    
    
//    init() {
//        guard let path = Bundle.main.path(forResource: "AvatarComponents", ofType: "json") else { return }
//        let url = URL(fileURLWithPath: path)
//        
//        do {
//            let data = try Data(contentsOf: url)
//            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//            
//            
//            guard let avatarComponentDictionaries = json as? [String: Any] else { return }
//            
//        } catch {
//            print(error)
//        }
//    }
    
    func buildAvatar(for gender: Person.Gender) -> UIImage {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 400))
        view.layer.zPosition = -1
        view.backgroundColor = .clear
        
        let color = colourPaletes.randomItem()
        let lightColor = color["Light"]
        let darkColor = color["Dark"]
        let hairColor = hairColours.randomItem()
        
        let backImageView = UIImageView(image: #imageLiteral(resourceName: "Back"))
        backImageView.tintColor = darkColor
        backImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        backImageView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height)
        backImageView.layer.zPosition = 1
        view.addSubview(backImageView)
        
        let stripes = UIImageView(image: shirtStripes.randomItem())
        if stripes.image != nil {
            stripes.tintColor = lightColor
            stripes.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            if stripes.image != #imageLiteral(resourceName: "StripesHorz") {
                stripes.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.6175)
            } else {
                stripes.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.67)
                
            }
            stripes.layer.zPosition = 1
            view.addSubview(stripes)
        }
        
        let faceImageView = UIImageView(image: skinColours.randomItem())
        faceImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        faceImageView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.745)
        faceImageView.layer.zPosition = 3
        view.addSubview(faceImageView)
        
        let noseImageView = UIImageView(image: noses.randomItem())
        if faceImageView.image == #imageLiteral(resourceName: "PeachFace") {
            noseImageView.tintColor = UIColor(red:0.99, green:0.71, blue:0.33, alpha:1.00)
        } else if faceImageView.image == #imageLiteral(resourceName: "BeigeFace") {
            noseImageView.tintColor = UIColor(red:0.53, green:0.46, blue:0.32, alpha:1.00)
        } else if faceImageView.image == #imageLiteral(resourceName: "BrownFace") {
            noseImageView.tintColor = UIColor(red:0.53, green:0.43, blue:0.24, alpha:1.00)
        }
        noseImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        noseImageView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.395)
        noseImageView.layer.zPosition = 4
        view.addSubview(noseImageView)
        
        
        let eyesImageView = UIImageView(image: eyes.randomItem())
        eyesImageView.tintColor = eyeColours.randomItem()
        eyesImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        eyesImageView.layer.position = CGPoint(x: faceImageView.bounds.width / 2, y: view.bounds.height * 0.25)
        eyesImageView.layer.zPosition = 3
        faceImageView.addSubview(eyesImageView)
        
        let mouthImageView = UIImageView(image: mouths.randomItem())
        mouthImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        mouthImageView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.4825)
        mouthImageView.layer.zPosition = 4
        view.addSubview(mouthImageView)
        
        let hairBackView = UIImageView(image: gender == .male ? maleHairBack.randomItem() : femaleHairBack.randomItem())
        hairBackView.tintColor = hairColor
        hairBackView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        hairBackView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.07)
        hairBackView.layer.zPosition = 0
        view.addSubview(hairBackView)
        
        let hairFrontView = UIImageView(image: gender == .male ? maleHairFront.randomItem() : femaleHairFront.randomItem())
        hairFrontView.tintColor = hairColor
        hairFrontView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.25)
        hairFrontView.layer.zPosition = 3
        hairFrontView.layer.position = CGPoint(x: view.bounds.width / 2, y: faceImageView.frame.minY)
        view.addSubview(hairFrontView)
        
        let facialHairView = UIImageView(image: gender == .male ? facialHair.randomItem() : nil)
        if facialHairView.image != nil {
            facialHairView.tintColor = hairColor
            facialHairView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            facialHairView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.4575)
            facialHairView.layer.zPosition = 3
            view.addSubview(facialHairView)
            
            
        }
        
        let avatarImage = view.renderToImage(afterScreenUpdates: true)
        
        
        return avatarImage
    }
}


