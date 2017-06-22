//
//  Components.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-17.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import Foundation
import Fakery

class Components {
    
    static let sharedComponentsData = Components()
    
    var dobs: [String] = []
    var expiryDates: [String] = []
    var maleFirstNames: [String] = []
    var femaleFirstNames: [String] = []
    var lastNames: [String] = []
    var maleAvatars: [String] = []
    var femaleAvatars: [String] = []
    var idBadges: [String] = []
    let skinColour: [String] = ["Peach", "Brown", "Beige"]
    
    enum Gender {
        case male
        case female
    }
    
    func buildPerson(gender: Gender) -> [String: Any] {
        let faker = Faker(locale: "en")
        
        let address = "\(faker.address.streetAddress(includeSecondary: true))\n\(faker.address.city()), \(faker.address.stateAbbreviation()) \(faker.address.postcode())"
        
        let personDictionary = [ "firstName": gender == .male ? maleFirstNames.randomItem() : femaleFirstNames.randomItem(), "lastName": lastNames.randomItem(), "dob": dobs.randomItem(), "expiryDate": expiryDates.randomItem(), "avatar": gender == .male ? maleAvatars.randomItem() : femaleAvatars.randomItem(), "idBadge": idBadges.randomItem(), "address": address]
        
        return personDictionary
    }
    
    
    init () {
        
        guard let path = Bundle.main.path(forResource: "Components", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            guard let componentDictionaries = json as? [String: Any] else { return }
            let dobs = componentDictionaries["birthdays"] as! [String]
            let expiryDates = componentDictionaries["expiryDates"] as! [String]
            let maleFirstNames = componentDictionaries["maleFirstNames"] as! [String]
            let femaleFirstNames = componentDictionaries["femaleFirstNames"] as! [String]
            let lastNames = componentDictionaries["femaleFirstNames"] as! [String]
            let maleAvatars = componentDictionaries["maleAvatars"] as! [String]
            let femaleAvatars = componentDictionaries["femaleAvatars"] as! [String]
            let idBadges = componentDictionaries["idBadges"] as! [String]
            
            self.dobs = dobs
            self.expiryDates = expiryDates
            self.maleFirstNames = maleFirstNames
            self.femaleFirstNames = femaleFirstNames
            self.lastNames = lastNames
            self.maleAvatars = maleAvatars
            self.femaleAvatars = femaleAvatars
            self.idBadges = idBadges
            
        } catch {
            print(error)
        }
    }
}
