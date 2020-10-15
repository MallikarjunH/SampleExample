//
//  RecalledAndDeclinedDocListTableViewCell.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 15/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class RecalledAndDeclinedDocListTableViewCell: UITableViewCell {

    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var docNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainBGView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
