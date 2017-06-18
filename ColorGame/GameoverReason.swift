//
//  GameoverReasons.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-17.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import Foundation

enum GameoverReason: String {
    case timerRanOutDuringNext = "You took too long to call up the next person, so you were fired!"
    case timerRanOutDuringPerson = "You are too slow. You're Fired!"
    case expiredID = "You let somebody in with an expired ID! You're fired!"
    case underage = "The person you just let in was underage! You're fired!"
    case wrongID = "You let somebody in that used a fake ID! You're fired!"
    case falseDeny = "Why are you turning away perfectly good customers? You're fired!"
}
