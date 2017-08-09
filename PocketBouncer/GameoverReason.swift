//
//  GameoverReasons.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-17.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import Foundation

enum GameoverReason: String {
    case timerRanOutDuringPerson = "You're too slow."
    case expiredID = "You let somebody in with an expired ID!"
    case underage = "The person you just let in was underage!"
    case wrongID = "You let somebody in that used a fake ID!"
    case falseDeny = "Why are you turning away perfectly good customers?"
    case expiredAndUnderage = "The person was underage AND their ID was expired!"
    case isWearingSunglasses = "Do you see the sign that says No Sunglasses?"
    case isWearingHat = "Do you see the sign that says No Hats?"
    case isWearingTie = "Do you see the sign that says No Ties?"
}

