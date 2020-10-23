//
//  SignatoryXibView.swift
//  SignDesign_Example
//
//  Created by Mallikarjun on 20/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class SignatoryXibView: UIView {

    @IBOutlet var contentView1: UIView!
    @IBOutlet weak var signatoryLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        
      
        
       guard let view = loadViewFromNib() else { return }
       view.frame = self.bounds
       self.addSubview(view)
       contentView1 = view
        
       contentView1.layer.borderWidth = 2.0
       contentView1.layer.borderColor = UIColor.green.cgColor

    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SignatoryXibView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

