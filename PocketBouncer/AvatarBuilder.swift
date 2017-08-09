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
    
    var skinColors: [[String: UIColor]] = [["Dark": UIColor(red:0.95, green:0.72, blue:0.40, alpha:1.00), "Light": UIColor(red:0.96, green:0.81, blue:0.58, alpha:1.00)], ["Dark": UIColor(red:0.54, green:0.42, blue:0.20, alpha:1.00), "Light": UIColor(red:0.72, green:0.56, blue:0.27, alpha:1.00)], ["Dark": UIColor(red:0.54, green:0.46, blue:0.29, alpha:1.00), "Light": UIColor(red:0.71, green:0.63, blue:0.46, alpha:1.00)]]
    var noses: [UIImage] = [#imageLiteral(resourceName: "WideNose"), #imageLiteral(resourceName: "RoundNose"), #imageLiteral(resourceName: "NormalNose")]
    var eyeColours: [UIColor] = [UIColor(red:0.28, green:0.59, blue:0.61, alpha:1.00), UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00), UIColor(red:0.31, green:0.65, blue:0.24, alpha:1.00), UIColor(red:0.54, green:0.42, blue:0.20, alpha:1.00)]
    var eyes: [UIImage] = [#imageLiteral(resourceName: "DownEyes"), #imageLiteral(resourceName: "HappyEyes"), #imageLiteral(resourceName: "NormalEyes")]
    var shirtAccessories = [nil, #imageLiteral(resourceName: "StripesHorz"), #imageLiteral(resourceName: "StripesVert"), #imageLiteral(resourceName: "Lapels"), #imageLiteral(resourceName: "Collar")]
    var mouths: [UIImage] = [#imageLiteral(resourceName: "MouthTongue"), #imageLiteral(resourceName: "HappySmallBlack"), #imageLiteral(resourceName: "SmallTongue"), #imageLiteral(resourceName: "HappySmallWhite"), #imageLiteral(resourceName: "Closed"), #imageLiteral(resourceName: "Round"), #imageLiteral(resourceName: "Singing")]
    var colourPaletes: [[String: UIColor]] = [["Dark": UIColor(red:0.19, green:0.19, blue:0.19, alpha:1.00), "Light": UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.00)], ["Dark": UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.00), "Light": UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.00)], ["Dark": UIColor(red:0.60, green:0.17, blue:0.14, alpha:1.00), "Light": UIColor(red:0.77, green:0.26, blue:0.23, alpha:1.00)], ["Dark": UIColor(red:0.72, green:0.48, blue:0.19, alpha:1.00), "Light": UIColor(red:0.84, green:0.60, blue:0.30, alpha:1.00)], ["Dark": UIColor(red:0.82, green:0.76, blue:0.26, alpha:1.00), "Light": UIColor(red:0.91, green:0.87, blue:0.39, alpha:1.00)], ["Dark": UIColor(red:0.30, green:0.62, blue:0.23, alpha:1.00), "Light": UIColor(red:0.38, green:0.77, blue:0.30, alpha:1.00)], ["Dark": UIColor(red:0.15, green:0.23, blue:0.60, alpha:1.00), "Light": UIColor(red:0.25, green:0.34, blue:0.77, alpha:1.00)], ["Dark": UIColor(red:0.40, green:0.18, blue:0.52, alpha:1.00), "Light": UIColor(red:0.49, green:0.29, blue:0.62, alpha:1.00)], ["Dark": UIColor(red:0.56, green:0.18, blue:0.39, alpha:1.00), "Light": UIColor(red:0.73, green:0.27, blue:0.53, alpha:1.00)]]
    var maleHairBack: [UIImage] = [#imageLiteral(resourceName: "Short")]
    var maleHairFront: [UIImage] = [#imageLiteral(resourceName: "Tuft"), #imageLiteral(resourceName: "Bobble"), #imageLiteral(resourceName: "LongFringeChip")]
    var facialHair = [nil, nil, #imageLiteral(resourceName: "BeardLarge"), #imageLiteral(resourceName: "BeardSmall")]
    var cheeks = [nil, #imageLiteral(resourceName: "Freckles"), #imageLiteral(resourceName: "CheeksRed"), #imageLiteral(resourceName: "Cheeks")]
    var femaleHairBack: [UIImage] = [#imageLiteral(resourceName: "Long"), #imageLiteral(resourceName: "MediumWings"), #imageLiteral(resourceName: "Tuck"), #imageLiteral(resourceName: "Afro")]
    var femaleHairFront: [UIImage] = [#imageLiteral(resourceName: "LongFringe"), #imageLiteral(resourceName: "Tuft")]
    var hairColours: [UIColor] = [UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.00), UIColor(red:0.54, green:0.46, blue:0.29, alpha:1.00), UIColor(red:0.95, green:0.91, blue:0.41, alpha:1.00), UIColor(red:0.89, green:0.64, blue:0.31, alpha:1.00), UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)]
    var glasses = [nil, nil, nil, #imageLiteral(resourceName: "RoundGlasses")]
    var sunglasses = [nil, nil, #imageLiteral(resourceName: "Sunglasses")]
    var hat = [nil, nil, nil, "hat"]
    var tie = [nil, nil, #imageLiteral(resourceName: "Tie")]
    
    func buildAvatar(for gender: Person.Gender, level: Int) -> (avatarImage: UIImage, wearingSunglasses: Bool, wearingHat: Bool, wearingTie: Bool) {
        var wearingSunglasses = false
        var wearingHat = false
        var wearingTie = false
        
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
        
        let skinColor = skinColors.randomItem()
        let faceImageView = UIImageView(image: #imageLiteral(resourceName: "Face"))
        faceImageView.tintColor = skinColor["Light"]
        faceImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        faceImageView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.115)
        faceImageView.layer.zPosition = 4
        view.addSubview(faceImageView)
        
        let earsImageView = UIImageView(image: #imageLiteral(resourceName: "Ears"))
        earsImageView.tintColor = skinColor["Dark"]
        earsImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        earsImageView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.3325)
        earsImageView.layer.zPosition = 4
        view.addSubview(earsImageView)
        
        let neckImageView = UIImageView(image: #imageLiteral(resourceName: "Neck"))
        neckImageView.tintColor = skinColor["Dark"]
        neckImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        neckImageView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.475)
        neckImageView.layer.zPosition = 3
        view.addSubview(neckImageView)
        
        let noseImageView = UIImageView(image: noses.randomItem())
        noseImageView.tintColor = skinColor["Dark"]
        noseImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        noseImageView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.395)
        noseImageView.layer.zPosition = 4
        view.addSubview(noseImageView)
        
        let shirtAccessoryView = UIImageView(image: shirtAccessories.randomItem())
        if shirtAccessoryView.image != nil {
            shirtAccessoryView.tintColor = lightColor
            shirtAccessoryView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            if shirtAccessoryView.image != #imageLiteral(resourceName: "StripesHorz") {
                shirtAccessoryView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.6175)
                shirtAccessoryView.layer.zPosition = 1
                if shirtAccessoryView.image == #imageLiteral(resourceName: "Lapels") {
                    shirtAccessoryView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.60)
                    shirtAccessoryView.layer.zPosition = 3
                    let undershirtView = UIImageView(image: #imageLiteral(resourceName: "Undershirt"))
                    undershirtView.tintColor = colourPaletes.randomItem()["Light"]
                    undershirtView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
                    undershirtView.layer.zPosition = 1
                    undershirtView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height)
                    view.addSubview(undershirtView)
                }
            } else {
                shirtAccessoryView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.67)
                shirtAccessoryView.layer.zPosition = 1
            }
            view.addSubview(shirtAccessoryView)
        }
        
        let eyesImageView = UIImageView(image: eyes.randomItem())
        eyesImageView.tintColor = eyeColours.randomItem()
        eyesImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        eyesImageView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.31)
        eyesImageView.layer.zPosition = 4
        view.addSubview(eyesImageView)
        
        let mouthImageView = UIImageView(image: mouths.randomItem())
        mouthImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        mouthImageView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.4825)
        mouthImageView.layer.zPosition = 5
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
        hairFrontView.layer.zPosition = 5
        hairFrontView.layer.position = CGPoint(x: view.bounds.width / 2, y: faceImageView.frame.minY)
        view.addSubview(hairFrontView)
        
        let facialHairView = UIImageView(image: gender == .male ? facialHair.randomItem() : nil)
        if facialHairView.image != nil {
            facialHairView.tintColor = hairColor
            facialHairView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            facialHairView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.4575)
            facialHairView.layer.zPosition = 4
            view.addSubview(facialHairView)
        }
        
        let cheeksView = UIImageView(image: gender == .female ? cheeks.randomItem() : nil)
        if cheeksView.image != nil {
            cheeksView.tintColor = skinColor["Dark"]
            cheeksView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            cheeksView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.3975)
            cheeksView.layer.zPosition = 4
            view.addSubview(cheeksView)
        }
        
        let glassesView = UIImageView(image: glasses.randomItem())
        if glassesView.image != nil {
            glassesView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            glassesView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.34)
            glassesView.layer.zPosition = 5
            view.addSubview(glassesView)
        }
        
        if level >= 2 {
            let sunglassesView = UIImageView(image: sunglasses.randomItem())
            if sunglassesView.image != nil {
                if glassesView.image == nil {
                    wearingSunglasses = true
                    sunglassesView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    sunglassesView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.34)
                    sunglassesView.layer.zPosition = 5
                    view.addSubview(sunglassesView)
                }
            }
        }
        
        if level >= 3 {
            let hatCheck = hat.randomItem()
            if hatCheck != nil {
                wearingHat = true
                let hatBottomView = UIImageView(image: #imageLiteral(resourceName: "HatBottom"))
                let hatTopView = UIImageView(image: #imageLiteral(resourceName: "HatTop"))
                let hatColor = colourPaletes.randomItem()
                hatBottomView.tintColor = hatColor["Light"]
                hatTopView.tintColor = hatColor["Dark"]
                hatBottomView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
                hatTopView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
                hatBottomView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.2825)
                hatTopView.layer.position = CGPoint(x: view.bounds.width / 2, y: 0)
                hatBottomView.layer.zPosition = 6
                hatTopView.layer.zPosition = 6
                view.addSubview(hatBottomView)
                view.addSubview(hatTopView)
            }
        }
        
        if level >= 4 {
            let tieView = UIImageView(image: tie.randomItem())
            if shirtAccessoryView.image != #imageLiteral(resourceName: "Collar") {
                if tieView.image != nil {
                    wearingTie = true
                    let tieColor = colourPaletes.randomItem()
                    tieView.tintColor = tieColor["Dark"]
                    let collarView = UIImageView(image: #imageLiteral(resourceName: "Collar"))
                    collarView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
                    collarView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.6175)
                    collarView.layer.zPosition = 2
                    tieView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
                    tieView.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.7325)
                    tieView.layer.zPosition = 1
                    view.addSubview(collarView)
                    view.addSubview(tieView)
                }
            }
        }
        
        // Extension that takes a "snapshot" of the UIView and converts it into a UIImageView
        let avatarImage = view.renderToImage(afterScreenUpdates: true)
        
        return (avatarImage, wearingSunglasses, wearingHat, wearingTie)
    }
}
