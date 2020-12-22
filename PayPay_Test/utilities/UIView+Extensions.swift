//
//  UIView+Extensions.swift
//  PayU_Test
//
//  Created by Manas1 Mishra on 19/12/20.
//


import UIKit

// Screen width.
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

let isIPAD  = (UI_USER_INTERFACE_IDIOM() == .pad)


struct ConstraintsCustom {
    var top: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    var leading: NSLayoutConstraint?
    var trailing: NSLayoutConstraint?
    var height: NSLayoutConstraint?
    var width: NSLayoutConstraint?
}

extension UIView {
    
    //Add constraints from 4Sides
    func addAsSubViewWithConstraints(_ superview: UIView, top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        self.frame = superview.bounds
        superview.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing).isActive = true
    }
    
}


