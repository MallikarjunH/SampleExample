//
//  SignatoryXibView.swift
//  SignDesign_Example
//
//  Created by Nikita on 20/10/20.
//  Copyright © 2020 Nikita. All rights reserved.
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
    
    override func didMoveToSuperview() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
    }
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        frame.translate(gesture.translation(in: self))
        gesture.setTranslation(.zero, in: self)
        setNeedsDisplay()
    }
}


extension  CGPoint {
    static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}

extension CGRect {
    mutating func translate(_ translation: CGPoint) {
        origin += translation
    }
}
