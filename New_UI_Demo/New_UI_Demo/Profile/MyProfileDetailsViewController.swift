//
//  MyProfileDetailsViewController.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 17/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class MyProfileDetailsViewController: UITableViewController {

    @IBOutlet var mainTableView: UITableView!
   
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Profile"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //nameTextField.text = "Test Name"
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
