//
//  LastThreeUsersTableViewCell.swift
//  MTB Cycle
//
//  Created by 30hills on 8/29/17.
//  Copyright © 2017 Djordje Srdic. All rights reserved.
//

import UIKit

class LastThreeUsersTableViewCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var lastSessionLabel: UILabel!
    
    var delegate : UserInfoProtocol?
    var tmpUser : User?
    var tmpUserPosition : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.setCustomCornerRadius(selectedView: cellView, radius: 20)
    }

    func initWith(lastThreeUser : Array<User>, position : Int, userInfoProtocolDelegate : UserInfoProtocol) {
        delegate = userInfoProtocolDelegate
        tmpUser = lastThreeUser[position]
        tmpUserPosition = position
        usernameLabel.text = lastThreeUser[position].userName
        lastSessionLabel.text = formatDate(endSessionDate: lastThreeUser[position].userEndSessionDate)
    }

    @IBAction func cellButtonAction(_ sender: Any) {
            delegate?.selectedCellInfo(user: tmpUser!)
    }
    
    func formatDate(endSessionDate : String?) -> String {
        guard let _ =  endSessionDate else {
            return "No date"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dateOne = dateFormatter.date(from: endSessionDate!)
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.string(from: dateOne!)
    }
}
