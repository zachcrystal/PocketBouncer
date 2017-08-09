//
//  GameViewDelegate.swift
//  PocketBouncer
//
//  Created by Zach Crystal on 2017-06-30.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import Foundation

protocol GameViewDelegate {
    
    func didTapStart()
    func didTapApprove()
    func didTapDeny()
    func didTapTryAgain()
    func didTapQuitToMenu()
}
