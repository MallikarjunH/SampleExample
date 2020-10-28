//
//  ViewController.swift
//  enlargeView
//
//  Created by Mallikarjun on 28/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sampleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        sampleView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
    }

    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began: break;
           /* let rectangle = Rectangle(frame: .init(origin: gesture.location(in: view), size: .init(width: 0, height: 0)))
            rectangle.fillColor = .red
            rectangle.strokeColor = .white
            rectangle.lineWidth = 3
            view.addSubview(rectangle)
            rectangles.append(rectangle) */
        case .changed:
            let distance = gesture.translation(in: view)
           // let index = rectangles.index(before: rectangles.endIndex)
            let frame = sampleView.frame
            sampleView.frame = .init(origin: frame.origin, size: .init(width: frame.width + distance.x, height: frame.height + distance.y))
            sampleView.setNeedsDisplay()
            gesture.setTranslation(.zero, in: view)
        case .ended:
            break
        default:
            break
        }
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
