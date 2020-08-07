//
//  RoundButton.swift
//  GallerySecurity
//
//  Created by coder on 7/12/20.
//  Copyright © 2020 cyber cradle. All rights reserved.
//

import UIKit

@IBDesignable

class RoundButton: UIButton {

    
    var loginViewController: LoginInViewController!
    
    @IBInspectable var cornerRadius: CGFloat = LoginInViewController. {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
