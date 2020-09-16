//
//  SelectWorkFlowViewController.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 11/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class SelectWorkFlowViewController: UIViewController {

    var nameArray = ["flexi","lopa","test","DT-iOS","mb_GB_Data","iOS11","test_reciewe","serial","Serial_workflow_fla","flexiform test","paralller sign","test iss 2"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Work Flows"
        
       // self.navigationController?.navigationBar.topItem?.title = ""
    }


}

extension SelectWorkFlowViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectWorkFlowTableViewCell", for: indexPath) as! SelectWorkFlowTableViewCell
        cell.titleLabel.text = nameArray[indexPath.row]
        
        return cell
    }
    
    
    
}
