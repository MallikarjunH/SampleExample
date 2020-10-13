//
//  DashboardViewController.swift
//  emSigner
//
//  Created by Mallikarjun on 14/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        
        let loginVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = loginVC
        self.window?.makeKeyAndVisible()
    }
    
}
