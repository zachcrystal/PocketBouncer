//
//  Components.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-17.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import Foundation

class Components {
    
    static let sharedComponentsData = Components()
    
    var dobs: [String] = []
    var expiryDates: [String] = []
    var maleFirstNames: [String] = []
    var femaleFirstNames: [String] = []
    var lastNames: [String] = []
    
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

            
            self.dobs = dobs
            self.expiryDates = expiryDates
            self.maleFirstNames = maleFirstNames
            self.femaleFirstNames = femaleFirstNames
            self.lastNames = lastNames
            
            
            
        } catch {
            print(error)
        }
        
    }
    
    
//    static func buildPerson() -> Person {
//        
//    }
    
}
