//
//  CustomView.swift
//  MTB Cycle
//
//  Created by 30hills on 8/9/17.
//  Copyright © 2017 Djordje Srdic. All rights reserved.
//

import UIKit

extension  UIView {
    
    func setCustomCornerRadius(selectedView view:UIView, radius : Double) {
        view.layer.cornerRadius = CGFloat(radius)
    }
    
    func customErrorViewWithTitle(errorTitle : String) {

        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor.lightText
        self.alpha = 0.8
        let errorTitleLabel = UILabel.init(frame: CGRect.init(x: 10, y: 10, width: self.frame.width - 20, height: self.frame.height - 20))
        errorTitleLabel.text = errorTitle
        errorTitleLabel.adjustsFontSizeToFitWidth = true
        errorTitleLabel.textAlignment = NSTextAlignment.center
        errorTitleLabel.backgroundColor = UIColor.clear
        self.addSubview(errorTitleLabel)

    }
    
}
