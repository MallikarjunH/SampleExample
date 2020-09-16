//
//  DocStoreViewController.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 11/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class DocStoreViewController: UIViewController {
    
    var docTypeImgArray = ["draft-1x","pending-1x","completed-1x", "completed-1x","pending-1x", "draft-1x"]
    var sentByNameArray = ["Harhsitha B","Mallikarjun","Sandeep Patil", "Mahesh Kothare","Rajesh Shelke", "Test Test"]
    var docnameArray = ["Appointment Letter format.pdf", "Holidays_list_2020.pdf", "Sample.pdf", "Test Document.pdf", "Appointment Letter format.pdf", "somedocument.pdf"]
    // var dateArray = ["10/09/20 22"]
    
    @IBOutlet weak var mainTablewView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Doc Store"
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    }
    
}

extension DocStoreViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocStoreTableViewCell", for: indexPath) as! DocStoreTableViewCell
        cell.docTypeImg.image = UIImage(named: docTypeImgArray[indexPath.row])
        cell.documentNamelLabel.text = docnameArray[indexPath.row]
        cell.sentByNameLabel.text = "send by: \(sentByNameArray[indexPath.row])"
        cell.dateLabel.text = "10/09/20 24:12:02"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "SelectWorkFlowViewController") as! SelectWorkFlowViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
     } */
    
    
}
