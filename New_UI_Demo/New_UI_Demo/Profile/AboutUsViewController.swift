//
//  AboutUsViewController.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 17/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit
import MessageUI

class AboutUsViewController: UIViewController,MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "About Us"
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func writeToUsButtonClicked(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail() {
            sendEmail()
        }
        else{
            
        }
    }

    @IBAction func termsOfUseButtonClicked(_ sender: Any) {
        
        if let url = URL(string: "https://emsigner.com/Areas/Home/termsofservice") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func privacyButtonClicked(_ sender: Any) {
        
        if let url = URL(string: "https://emsigner.com/Areas/Home/privacypolicy") {
            UIApplication.shared.open(url)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["mallikarjun.h1410@gmail.com"])
           // mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

