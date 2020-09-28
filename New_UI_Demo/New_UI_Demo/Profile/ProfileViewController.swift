//
//  ProfileViewController.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 16/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    let menuListArray = ["About","My Profile","Change Password", "Feedback", "Log Out"]
    let menuImgArray = ["aboutAccount","profilePerson","changePassword", "starIcon", "logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "My Account"
        mainTableView.tableFooterView = UIView()
        
        
    }

    func updateProfileDetails() {
    
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
        }else{
            
            return menuListArray.count
        }
    }
    
    //You are subscribed to Professional Plan
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTopTableViewCell", for: indexPath) as! ProfileTopTableViewCell
            cell.selectionStyle = .none
            
            cell.profileNameLabel.text = "Varun"
            
            let boldAttribute = [
               //NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 17.0)!
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
            ]
            let regularAttribute = [
               //NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 17.0)!
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)
            ]
        //UIFontWeightUltraLight,UIFontWeightThin,UIFontWeightLight,UIFontWeightRegular,UIFontWeightMedium,UIFontWeightSemibold,UIFontWeightBold,UIFontWeightHeavy,UIFontWeightBlack
            
            let regularText1 = NSAttributedString(string: "You are subscribed to ", attributes: regularAttribute)
            let boldText = NSAttributedString(string: "Professional ", attributes: boldAttribute)
            let regularText2 = NSAttributedString(string: "Plan", attributes: regularAttribute)
            
            let newString = NSMutableAttributedString()
            newString.append(regularText1)
            newString.append(boldText)
            newString.append(regularText2)
            
            cell.subscriptionPlanLabel.attributedText = newString
            
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuTableViewCell", for: indexPath) as! ProfileMenuTableViewCell
            cell.selectionStyle = .none
            cell.typeNameLabel.text = menuListArray[indexPath.row]
            cell.typeImg.image = UIImage(named: menuImgArray[indexPath.row])
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 215.0
        }else{
            
            return 55.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
        }
        else{
            if indexPath.row == 0 {
                print("Clikced on About")
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let aboutsVC = storyBoard.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                self.navigationController?.pushViewController(aboutsVC, animated: true)
            }
            else if indexPath.row == 1 {
                print("Clikced on My Profile")
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let myProfileVC = storyBoard.instantiateViewController(withIdentifier: "MyProfileDetailsViewController") as! MyProfileDetailsViewController
                self.navigationController?.pushViewController(myProfileVC, animated: true)
            }
            else if indexPath.row == 2 {
                print("Clikced on Change Password")
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let changePasswordVC = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
            }
            else if indexPath.row == 3 {
                 print("Clikced on Feedback")
                 
                if let url = URL(string: "https://itunes.apple.com/us/app/apple-store/id1246670687?mt=8") {
                    UIApplication.shared.open(url)
                }
                
            }
            else if indexPath.row == 4 { 
                print("Clikced on Logout")
            }
        }
    }
    
}
