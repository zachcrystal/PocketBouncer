//
//  Person.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-12.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit
import WebKit

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
    
    init(jsonDictionary: [String: Any]) {
        self.firstName = jsonDictionary["firstname"] as! String
        self.lastName = jsonDictionary["lastname"] as! String
        
        self.dob = jsonDictionary["birthday"] as! String
        let strDob = dob
        let ageComponents = strDob.components(separatedBy: "-")
        let dateDob = Calendar.current.date(from: DateComponents(year: Int(ageComponents[2]), month: Int(ageComponents[1]), day: Int(ageComponents[0])))!
        self.age = dateDob.ageInt
        
        self.address = jsonDictionary["address"] as! String
        let imageString = jsonDictionary["imageString"] as! String
        self.avatarDictionary = [imageString: UIImage(named: imageString)!]
        
        self.expiryDateString = jsonDictionary["expiryDate"] as! String
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd-yyyy"
        let date = dateFormatterGet.date(from: expiryDateString)
        self.expiryDateTimeStamp = date?.timeIntervalSince1970 ?? 0
        
        let idBadgeString = jsonDictionary["idBadge"] as! String
        self.idBadge = UIImage(named: idBadgeString)!
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.dob == rhs.dob
    }
}

