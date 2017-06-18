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
    var dobTest: String? = nil
    let age: Int
    let address: String
    let expiryDateString: String
    let expiryDateTimeStamp: Double
    let avatarDictionary: [String: UIImage]
    let idBadge: UIImage
    
    init(personDictionary: [String: Any]) {
        self.firstName = personDictionary["firstName"] as! String
        self.lastName = personDictionary["lastName"] as! String
        
        self.dob = personDictionary["dob"] as! String
        let strDob = dob
        let ageComponents = strDob.components(separatedBy: "-")
        let dateDob = Calendar.current.date(from: DateComponents(year: Int(ageComponents[2]), month: Int(ageComponents[1]), day: Int(ageComponents[0])))!
        self.age = dateDob.ageInt
        
//        self.address = personDictionary["address"] as! String
        self.address = "123 Fake Street"
        let imageString = personDictionary["avatar"] as! String
        self.avatarDictionary = [imageString: UIImage(named: imageString)!]
        
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

