//
//  GlobalVariable.swift
//  SignDesign_Example
//
//  Created by Mallikarjun on 27/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import Foundation
import UIKit

class GlobalVariables {
    
    // These are the properties you can store in your singleton
    private var myName: String = "bob"
  
    var userRole:String?
    
    var currentFrame:CGRect?
    
   // var openTicketsCount:Int?
    
   // var dependencyDataDictionary:[String:Any]?
    
  
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
    
    private init() {
        
    }
}
