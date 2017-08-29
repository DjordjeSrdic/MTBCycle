//
//  TVProtocols.swift
//  MTB Cycle
//
//  Created by 30hills on 8/28/17.
//  Copyright © 2017 Djordje Srdic. All rights reserved.
//

import Foundation

protocol DeleteUserProtocol {
    func selectedCellInfo(user : User, position : Int)
}

protocol UserInfoProtocol {
    func selectedCellInfo(user : User)
}
