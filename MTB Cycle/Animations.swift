//
//  Animations.swift
//  MTB Cycle
//
//  Created by 30hills on 8/18/17.
//  Copyright © 2017 Djordje Srdic. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func logInButtonAnimation(animation:@escaping () -> (),completition:@escaping (Bool) -> ()) {
        UIView.animate(withDuration: 2,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations:animation,
                       completion: completition)
    }
    
    func signUpButtonAnimation(animation :@escaping () -> (), completition : ((Bool) ->())? ) {
        UIView.animate(withDuration: 2,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations:animation,
                       completion: completition)
    }
    
    func sunMovementAnimation(skyView : UIView, sunImage : UIImageView) {
        self.view.addSubview(sunImage)
        let bezierPath = UIBezierPath()
        let sunDawnPoint = CGPoint(x: -45, y: skyView.frame.size.height - 65)
        let sunNoonPoint = CGPoint(x: skyView.frame.midX, y: -20)
        let sunDuskPoint = CGPoint(x: skyView.frame.size.width + 45, y: skyView.frame.size.height - 65)
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        bezierPath.move(to: sunDawnPoint)
        bezierPath.addQuadCurve(to: sunDuskPoint, controlPoint: sunNoonPoint)
        bezierPath.addQuadCurve(to: CGPoint.init(x: sunDuskPoint.x + 200, y: sunDuskPoint.y),
                                controlPoint: CGPoint.init(x: sunDuskPoint.x + 100, y: sunDuskPoint.y))
        
        anim.path = bezierPath.cgPath
        anim.duration = 20
        anim.repeatCount = Float.infinity
        sunImage.layer.add(anim, forKey: "animate position on path")
    }
    
    func moonMovementAnimation(skyView : UIView, moonImage : UIImageView) {
        self.view.addSubview(moonImage)
        let bezierPath = UIBezierPath()
        let duskPoint = CGPoint(x: -45, y:skyView.frame.size.height - 65)
        let midnightPoint = CGPoint(x: skyView.frame.midX, y: -25)
        let dawnPoint = CGPoint(x: skyView.frame.size.width + 45, y:skyView.frame.size.height - 65)
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        bezierPath.move(to: duskPoint)
        bezierPath.addQuadCurve(to: dawnPoint, controlPoint: midnightPoint)
        bezierPath.addQuadCurve(to: CGPoint.init(x: dawnPoint.x + 200, y: dawnPoint.y),
                                controlPoint: CGPoint.init(x: dawnPoint.x + 100, y: dawnPoint.y))
        
        anim.path = bezierPath.cgPath
        anim.duration = 20
        anim.beginTime = CACurrentMediaTime() + 10.0
        anim.repeatCount = Float.infinity
        moonImage.layer.add(anim, forKey: "animate position on path")
    }

    func animateDayNightCycle(controller : LogInViewController) {
        UIView.animate(withDuration: 10,
                       delay: 5,
                       options: [.repeat, .autoreverse],
                       animations: {
                            controller.dayNightSkyView.alpha = 0.6
                        
                    }, completion: nil)
    }
    
    
    func showErrorWithAnimation(_ sender : AnyObject) {
        let errorView = UIView.init(frame: CGRect.init(x: 30.0, y: self.view.frame.size.height, width: self.view.frame.size.width - 60, height: 80.0))
        self.view.addSubview(errorView)
        errorView.customErrorViewWithTitle(errorTitle: sender.userInfo[NSLocalizedDescriptionKey] as! String)
        
        UIView.animate(withDuration: 2,
                       delay: 0,
                       options: [.transitionCurlUp,.autoreverse],
                       animations: {
                            errorView.frame.origin = CGPoint.init(x: Double(errorView.frame.origin.x), y: Double(errorView.frame.origin.y - errorView.frame.size.height - 15 ))
                    }, completion: {
                        (success) in
                        errorView.removeFromSuperview()
                    })
    }
    
    
    func showViewAnimation(animation:@escaping () -> (), completition:@escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: animation,
                       completion: completition)
    }
    
    func hideViewAnimation(animation:@escaping () -> (), completition:@escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: animation,
                       completion: completition)
    }
}
