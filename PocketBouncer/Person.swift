//
//  Person.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-12.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

class Person: Equatable {
    let firstName: String
    let lastName: String
    let dob: String
    let age: Int
    let address: String
    let expiryDateString: String
    let expiryDateTimeStamp: Double
    let avatarDictionary: [String: UIImage]
    let idBadge: UIImage
    
    enum Gender {
        case male
        case female
    }
    
    init(personDictionary: [String: Any], gender: Gender, level: Int) {
        self.firstName = personDictionary["firstName"] as! String
        self.lastName = personDictionary["lastName"] as! String
        
        let dob = personDictionary["dob"] as! String
        let dobDateFormatter = DateFormatter()
        dobDateFormatter.dateFormat = "MM-dd-yyyy"
        let dobDate = dobDateFormatter.date(from: dob)
        
        dobDateFormatter.dateStyle = .medium
        
        self.dob = dobDateFormatter.string(from: dobDate!)

        let ageComponents = dob.components(separatedBy: "-")
        let dateDob = Calendar.current.date(from: DateComponents(year: Int(ageComponents[2]), month: Int(ageComponents[1]), day: Int(ageComponents[0])))!
        self.age = dateDob.ageInt
        
        self.address = personDictionary["address"] as! String
        
        let avatarBuilder = AvatarBuilder.avatarBuilder
        let avatar = avatarBuilder.buildAvatar(for: gender)
        let uuid = UUID().uuidString
        
        self.avatarDictionary = [uuid: avatar]
        
        self.expiryDateString = personDictionary["expiryDate"] as! String
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd-yyyy"
        let date = dateFormatterGet.date(from: expiryDateString)
        self.expiryDateTimeStamp = date?.timeIntervalSince1970 ?? 0
        
        let idBadgeString = personDictionary["idBadge"] as! String
        self.idBadge = UIImage(named: idBadgeString)!
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.dob == rhs.dob
    }
}

