//: Playground - noun: a place where people can play

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}


let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 350))
view.backgroundColor = .white
let backImageView = UIImageView(image: #imageLiteral(resourceName: "Back.png"))
backImageView.tintColor = .blue
backImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
backImageView.layer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height)

view.addSubview(backImageView)
backImageView.tintColor = .green
