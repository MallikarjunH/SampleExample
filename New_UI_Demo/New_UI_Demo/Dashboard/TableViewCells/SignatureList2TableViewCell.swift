//
//  SignatureList2TableViewCell.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 13/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class SignatureList2TableViewCell: UITableViewCell {

    @IBOutlet weak var mainBGView: UIView!

    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var sentByNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
