//
//  DashboardCollectionViewCell.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 16/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var typeImg: UIImageView!
    @IBOutlet weak var typeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       mainBGView.layer.cornerRadius = 8
        
    }
}
