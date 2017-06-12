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
//    let age: Int
    let avatarDictionary: [String: UIImage]
    
    init(jsonDictionary: [String: Any]) {
        self.firstName = jsonDictionary["firstname"] as! String
        self.lastName = jsonDictionary["lastname"] as! String
        self.dob = jsonDictionary["birthday"] as! String
        
        let imageString = jsonDictionary["imageString"] as! String
        self.avatarDictionary = [imageString: UIImage(named: imageString)!]
        
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.dob == rhs.dob
    }
}

