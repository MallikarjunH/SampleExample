//
//  Utils.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 15/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import Foundation
import UIKit

public  func showAlert(title:String, message:String, vc: UIViewController) {
    
    let alertView1 = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertView1.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
    vc.present(alertView1,animated: true,completion: nil)
}
