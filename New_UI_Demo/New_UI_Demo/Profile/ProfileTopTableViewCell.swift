//
//  ProfileTopTableViewCell.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 16/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class ProfileTopTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var subscriptionPlanLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
