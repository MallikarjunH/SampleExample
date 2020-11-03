//
//  QRCodeXibView.swift
//  SignDesign_Example
//
//  Created by Mallikarjun on 03/11/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class QRCodeXibView: UIView {

    @IBOutlet var contentView1: UIView!
    @IBOutlet weak var removeQRCodeButton: UIButton!
    @IBOutlet weak var signatoryPositionLabel: UILabel!
    
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
        
       contentView1.layer.borderWidth = 1.0
       contentView1.layer.borderColor = UIColor.blue.cgColor
        
       removeQRCodeButton.addTarget(self, action: #selector(removeQRCodeButtonAction), for: .touchUpInside)
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "QRCodeXibView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func didMoveToSuperview() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panNew)))
    }
    
    //Drag/Move View
    @objc func panNew(_ gesture: UIPanGestureRecognizer) {
        translate(gesture.translation(in: self))
        gesture.setTranslation(.zero, in: self)
        setNeedsDisplay()
        print("QRCode Frame after Moving View: \(frame)")
    }
    
    @objc func removeQRCodeButtonAction(sender: UIButton!) {
        
       // let tagValue:Int = self.tag
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getSelectedTag"), object: nil, userInfo: ["sampleDict" : tagValue])
    }
}
