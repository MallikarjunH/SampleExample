//
//  DeclinedViewController.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 13/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class DeclinedViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
   
    var documentNameArray = ["Singatories Data.pdf","MacBoook List.pdf","Appointment Letter.pdf","iPhone series.pdf","Android series.pdf"]
    var sentByNameArray = ["Amit Kumar", "Ayush J", "Seema G", "Prahsant U", "Ishan P"]
    var dateArray = ["10/09/2020 22:00:04","10/09/2020 22:00:04","10/09/2020 22:00:04","10/09/2020 22:00:04","10/09/2020 22:00:04"]
    var showHideMoreButtonArray = [false, true, false, true, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Declined"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Do any additional setup after loading the view.
        
        mainTableView.register(UINib(nibName: "SignatureList2TableViewCell", bundle: nil), forCellReuseIdentifier: "SignatureList2TableViewCell")
    }
    
}


extension DeclinedViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignatureList2TableViewCell") as! SignatureList2TableViewCell
        
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
        print("Navigate to next VC")
    }
}
