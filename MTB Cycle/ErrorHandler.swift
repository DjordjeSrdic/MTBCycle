//
//  ErrorHandler.swift
//  MTB Cycle
//
//  Created by 30hills on 8/23/17.
//  Copyright © 2017 Djordje Srdic. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorHandlerProtocol {
    
    func createError(errorName : String, errorCodeNumber : Int, errorReason : String)
    func setUpErrorNotification(error : NSError)

}

extension ErrorHandlerProtocol where Self : UIViewController {
    
    func createError(errorName : String, errorCodeNumber : Int, errorReason : String) {
        let customError = NSError(domain:errorName , code: errorCodeNumber, userInfo: [NSLocalizedDescriptionKey : errorReason])
        setUpErrorNotification(error: customError)
    }
    
    func setUpErrorNotification(error : NSError ) {
                NotificationCenter.default.post(name: .init("ManageError"), object: nil, userInfo: error.userInfo)
    }
    
}
