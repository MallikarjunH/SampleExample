//
//  CompletedViewController.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 13/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class CompletedViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
   
    var documentNameArray = ["Holidays List.pdf","ESS Testing.pdf"]
    var sentByNameArray = ["Piyush Oswal", "Jayesh K"]
    var dateArray = ["10/09/2020 22:00:04","10/09/2020 22:00:04"]
    var showHideMoreButtonArray = [false, true, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Completed"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Do any additional setup after loading the view.
        
        mainTableView.register(UINib(nibName: "SignatureList1TableViewCell", bundle: nil), forCellReuseIdentifier: "SignatureList1TableViewCell")
    }
    
}

extension CompletedViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignatureList1TableViewCell") as! SignatureList1TableViewCell
        
        cell.fileNameLabel.text = documentNameArray[indexPath.row]
        cell.sentByNameLabel.text = "Sent by: \(sentByNameArray[indexPath.row])"
        cell.dateLabel.text = dateArray[indexPath.row]
        
        let showHideMoreButton = showHideMoreButtonArray[indexPath.row]
        if showHideMoreButton {
            cell.moreImg.isHidden = false
        }else{
            cell.moreImg.isHidden = true
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moreImageTapped(tapGestureRecognizer:)))
        cell.moreImg.isUserInteractionEnabled = true
        cell.moreImg.addGestureRecognizer(tapGestureRecognizer)
        
        return cell
    }
    
    @objc func moreImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("Clicked on more button")
        
    
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
       
    
        alert.addAction(UIAlertAction(title: "View Document Information", style: .default , handler:{ (UIAlertAction)in
            print("User click - View Document Information")
        }))

        alert.addAction(UIAlertAction(title: "Decline Document", style: .default , handler:{ (UIAlertAction)in
            print("User click - Decline Document")
        }))

        alert.addAction(UIAlertAction(title: "Download Document", style: .default , handler:{ (UIAlertAction)in
            print("User click - Download Document")
        }))
        
        alert.addAction(UIAlertAction(title: "Share Document", style: .default , handler:{ (UIAlertAction)in
            print("User click - Share Document")
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Cancel button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
