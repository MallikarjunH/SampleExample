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
    @IBOutlet weak var enlargeButotn: UIButton!
    @IBOutlet weak var removeSignatoryButton: UIButton!
    
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

      enlargeButotn.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(enLargeViewPan))) //Enlarge View
      removeSignatoryButton.addTarget(self, action: #selector(cancelButton), for: .touchUpInside) //Drag/Move View
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SignatoryXibView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func didMoveToSuperview() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
    }
    
    //Drag/Move View
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        translate(gesture.translation(in: self))
        gesture.setTranslation(.zero, in: self)
        setNeedsDisplay()
        print("Frame after Moving View: \(frame)")
    }
    
    //EnlargeView //H - 60 and w - 120
    @objc func enLargeViewPan(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
           break
        case .changed:
            let distance = gesture.translation(in: self)
          //  let frame = sampleView.frame
            
            if frame.width < 120.0 || frame.height < 60.0{
               print("Do not increase") //Restrict size while decreasing the view
                frame = .init(origin: frame.origin, size: .init(width: 120.0, height: 60.0))
            }
            else{
                 print("increase")
                 frame = .init(origin: frame.origin, size: .init(width: frame.width + distance.x, height: frame.height + distance.y))
            }
            setNeedsDisplay()
            gesture.setTranslation(.zero, in: self)
            
          /* let distance = gesture.translation(in: self)
            // let frame = sampleView.frame
             frame = .init(origin: frame.origin, size: .init(width: frame.width + distance.x, height: frame.height + distance.y))
            setNeedsDisplay()
            gesture.setTranslation(.zero, in: self) */
            
            print("Frame after Exapanding View: \(frame)")
        case .ended:
            break
        default:
            break
        }
    }
    
    //Testing - Get Tag from Current SignatoryView
    @objc func cancelButton(sender: UIButton!) {
        //print("Selected Tag: \( self.tag)")
        //ViewController().getCurrentSelectedTagMethod(someIndex: self.tag)
        let tagValue:Int = self.tag
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getSelectedTagForSignatoryView"), object: nil, userInfo: ["sampleDict" : tagValue])
    }
    
}


extension  CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
        
    }
    static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}
extension UIView {
    func translate(_ translation: CGPoint) {
        let destination = center + translation
        let minX = frame.width/2
        let minY = frame.height/2
        let maxX = superview!.frame.width-minX
        let maxY = superview!.frame.height-minY
        center = CGPoint(
            x: min(maxX, max(minX, destination.x)),
            y: min(maxY ,max(minY, destination.y)))
    }
}
