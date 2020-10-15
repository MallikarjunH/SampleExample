//
//  RecalledAndDeclinedDocListVC.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 15/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class RecalledAndDeclinedDocListVC: UIViewController {

    
    @IBOutlet weak var mainTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Documents List"
    }

}

extension RecalledAndDeclinedDocListVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecalledAndDeclinedDocListTableViewCell", for: indexPath) as! RecalledAndDeclinedDocListTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Move to next VC")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           
           return 57
       }
}
