//
//  GameViewController+Animations.swift
//  PocketBouncer
//
//  Created by Zach Crystal on 2017-07-01.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

extension GameViewController {
    
    func didTapStartAnimations() {
        self.gameView.tableImageView.frame = CGRect(x: 0, y: self.gameView.bounds.height, width: self.gameView.bounds.width, height: self.gameView.bounds.height * 0.4)
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.gameView.tableImageView.frame = CGRect(x: 0, y: self.gameView.bounds.height * 0.60, width: self.gameView.bounds.width, height: self.gameView.bounds.height * 0.4)
        })
        self.gameView.denyButton.isHidden = false
        gameView.denyButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
        UIView.animate(withDuration: 1.0, delay: 0.4, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
            self.gameView.denyButton.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        })
        self.gameView.approveButton.isHidden = false
        gameView.approveButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
        UIView.animate(withDuration: 1.0, delay: 1.4, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
       
            self.gameView.approveButton.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }) { (_) in
            self.presentNextPerson()
        }
    }
    
    func didTapQuitAnimations() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.IDCardView.center.x = -self.gameView.bounds.width / 2
        }) { (_) in
            self.IDCardView.center.y = self.gameView.frame.size.height / 1.39
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.personImageView.center.x = -self.gameView.bounds.width / 2
        })
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.gameView.tableImageView.frame = CGRect(x: 0, y: self.gameView.bounds.height, width: self.gameView.bounds.width, height: self.gameView.bounds.height * 0.4)
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.6, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
            self.gameView.denyButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
            self.gameView.denyButton.isHidden = true
        }) { (_) in
            self.putIDCardDown()
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.8, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.curveEaseIn], animations: {
            self.gameView.approveButton.layer.transform = CATransform3DMakeScale(0, 0, 0)
            self.gameView.approveButton.isHidden = true
        }) { (_) in
            self.gameView.startButton.isHidden = false
        }
    }
    
    func flashRed() {
        let redBorderFlash = UIImageView(frame: view.frame)
        redBorderFlash.image = #imageLiteral(resourceName: "RedBorderFlash")
        redBorderFlash.alpha = 1
        redBorderFlash.layer.zPosition = 1200
        view.addSubview(redBorderFlash)
        
        UIView.animate(withDuration: 4, animations: {
            redBorderFlash.alpha = 0
        }) { (_) in
            redBorderFlash.removeFromSuperview()
        }
    }
}
