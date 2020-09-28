//
//  ChangePasswordViewController.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 21/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UITableViewController {
    
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var imageView1 = UIImageView();
    var imageView2 = UIImageView();
    var imageView3 = UIImageView();
    
    var hidePassword1 = true
    var hidePassword2 = true
    var hidePassword3 = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Change Password"
        configureUIForShowHideButtonOnTextField()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureUIForShowHideButtonOnTextField() {
        
        //Current Password
        imageView1.image = UIImage(named: "hideIcon")
        currentPasswordTextField.rightView = imageView1
        currentPasswordTextField.rightViewMode = UITextField.ViewMode.always
        currentPasswordTextField.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
        imageView1.isUserInteractionEnabled = true
        imageView1.addGestureRecognizer(tapGestureRecognizer)
        
        //New Password
        imageView2.image = UIImage(named: "hideIcon")
        newPasswordTextField.rightView = imageView2
        newPasswordTextField.rightViewMode = UITextField.ViewMode.always
        newPasswordTextField.rightViewMode = .always
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
        imageView2.isUserInteractionEnabled = true
        imageView2.addGestureRecognizer(tapGestureRecognizer2)
        
        //Confirm Password
        imageView3.image = UIImage(named: "hideIcon")
        confirmPasswordTextField.rightView = imageView3
        confirmPasswordTextField.rightViewMode = UITextField.ViewMode.always
        confirmPasswordTextField.rightViewMode = .always
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(tapGestureRecognizer:)))
        imageView3.isUserInteractionEnabled = true
        imageView3.addGestureRecognizer(tapGestureRecognizer3)

    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("Clicked on first textField")
        
        if hidePassword1 {
            hidePassword1 = false
            imageView1.image = UIImage(named: "showIcon")
            print("Show Password")
        }else{
            hidePassword1 = true
            imageView1.image = UIImage(named: "hideIcon")
            print("Hide Password")
        }
        
    }
    
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("Clicked on Second textField")
        
        if hidePassword2 {
            hidePassword2 = false
            imageView2.image = UIImage(named: "showIcon")
            print("Show Password")
        }else{
            hidePassword2 = true
            imageView2.image = UIImage(named: "hideIcon")
            print("Hide Password")
        }
        
    }
    
    @objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("Clicked on Third textField")
        
        if hidePassword3 {
            hidePassword3 = false
            imageView3.image = UIImage(named: "showIcon")
            print("Show Password")
        }else{
            hidePassword3 = true
            imageView3.image = UIImage(named: "hideIcon")
            print("Hide Password")
        }
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        print("Clicked on Save Button")
    }
    
}
