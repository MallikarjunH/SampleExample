//
//  DocStoreViewController.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 11/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class DocStoreViewController: UIViewController {

    @IBOutlet weak var mainTablewView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

extension DocStoreViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocStoreTableViewCell", for: indexPath) as! DocStoreTableViewCell
        
        return cell
    }
    
   /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
    } */
    
    
}
