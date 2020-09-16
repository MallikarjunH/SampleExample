//
//  LoginViewController.swift
//  emSigner
//
//  Created by Mallikarjun on 26/08/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        
         self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "userLoggedIn")
        UserDefaults.standard.set(true, forKey: "showIntroScreen")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
     //   homeVC.modalPresentationStyle = .fullScreen
      //  self.present(homeVC, animated: true, completion: nil)
        
    }
}
