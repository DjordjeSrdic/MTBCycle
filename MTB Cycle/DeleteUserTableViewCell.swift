//
//  DeleteUserTableViewCell.swift
//  MTB Cycle
//
//  Created by 30hills on 8/25/17.
//  Copyright © 2017 Djordje Srdic. All rights reserved.
//

import UIKit

class DeleteUserTableViewCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var username: UILabel!
    @IBOutlet var userLastSession: UILabel!
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var unLabel: UILabel!
    @IBOutlet var lsLabel: UILabel!
    
    var tmpUser : User?
    var cellPosition : Int?
    var deleteCellDelegate : DeleteUserProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.setCustomCornerRadius(selectedView: cellView, radius: 20)
        
    }

    

    func initCellWith(user : Array<User>, position : Int, delegate : DeleteUserProtocol, selectedCellPosition : Int) {
        if selectedCellPosition == position {
            statusImageView.image = UIImage.init(named: "check_circle")
            changeTFTextColor(selected: true)
        } else {
            changeTFTextColor(selected: false)
            statusImageView.image = nil
        }
        
        deleteCellDelegate = delegate
        tmpUser = user[position]
        cellPosition = position
        username.text = user[position].userName
        userLastSession.text = formatDate(endSessionDate: user[position].userEndSessionDate)
    }
    
    func changeTFTextColor(selected : Bool) {
        let cellBackgroundColor : UIColor = (selected) ? Colors.customDarkGreen : .white
        let imageBackgroundColor : UIColor = (selected) ? Colors.customDarkGreen : .clear
        let textColor : UIColor = (selected) ? .white : .black
       
        cellView.backgroundColor = cellBackgroundColor
        statusImageView.backgroundColor = imageBackgroundColor
        unLabel.textColor = textColor
        lsLabel.textColor = textColor
        username.textColor = textColor
        userLastSession.textColor = textColor
    }
    
    @IBAction func userSelectedButtonAction(_ sender: Any) {
          deleteCellDelegate?.selectedCellInfo(user: tmpUser!, position: cellPosition!)
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
