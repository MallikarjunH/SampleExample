//
//  SearchResultUsersTableViewCell.swift
//  SignDesign_Example
//
//  Created by Nikita on 19/10/20.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit

class SearchResultUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var mainBackgroundView: UIView!
   
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
