//
//  RecalledViewController.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 13/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class RecalledViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    
    var documentNameArray = ["eMudhra Joining for.pdf","dummy.pdf","Appointment Letter.pdf","ESS_SampleDoc.pdf"]
    var sentByNameArray = ["Sanjay Kumar", "Manish Pal", "Amit Patil", "Kedar K"]
    var dateArray = ["10/09/2020 22:00:04","10/09/2020 22:00:04","10/09/2020 22:00:04","10/09/2020 22:00:04"]
    var showHideMoreButtonArray = [false, true, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Recalled"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Do any additional setup after loading the view.
        
        mainTableView.register(UINib(nibName: "SignatureList2TableViewCell", bundle: nil), forCellReuseIdentifier: "SignatureList2TableViewCell")
    }

}

extension RecalledViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyBoard.instantiateViewController(withIdentifier: "RecalledAndDeclinedDocListVC") as! RecalledAndDeclinedDocListVC
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showAlert(title: "Remarks", message: "some test message", vc: self)
    }
}
