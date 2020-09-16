//
//  DocStoreTableViewCell.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 11/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class DocStoreTableViewCell: UITableViewCell {

    @IBOutlet weak var mainBGView: UIView!
    
    @IBOutlet weak var docTypeImg: UIImageView!
    @IBOutlet weak var documentNamelLabel: UILabel!
    @IBOutlet weak var sentByNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainBGView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
