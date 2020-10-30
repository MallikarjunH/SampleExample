//
//  SearchAndSelectUserVC.swift
//  SignDesign_Example
//
//  Created by Mallikarjun on 19/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

protocol SendSelectedUserData {
    
    func dataPassing(userName:String, userEmail:String, userType: String)
}

class SearchAndSelectUserVC: UIViewController {

    @IBOutlet weak var searchBGView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var usersListTableView: UITableView!
    
    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!
    
  //  @IBOutlet weak var signerButton: UIButton!
  //  @IBOutlet weak var reviewerButton: UIButton!

    
    var userNameArray = ["ME","George Gamow","Angel Alcala", "Sheldon", "Luigi Galvani", "Jane Goodall", "Svante Arrhenius", "William Herschel", "Max Planck", "Jack Horner"]
    var userEmailArray = ["mallikarjun@gmail.com","george.amow@yahoo.com","angel.a@emudhra.com", "sheldon.lee@yahoo.com", "luigi.g@emudhra.com", "jane.goodall@gmail.com","svante.hk@gmail.com", "william.h@yahoo.com", "max.planck@gmail.com", "jack.horner@yahoo.com"]
    
    var userSelectedType = ""
    var selectedIndex = 0
    var delegate:SendSelectedUserData!
    
    var signersAndReviewersListArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Select User"
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissCurrentVC))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //self.setNavigationBar()
    
        //Search
        self.searchBGView.layer.borderColor = UIColor.gray.cgColor
        self.searchBGView.layer.borderWidth = 0.3
        self.searchBGView.layer.cornerRadius = 5
        
        //Default type
        userSelectedType = "signer"
        
    }
    
    @IBAction func segmentedControllerAction(_ sender: Any) {
        
        if segmentControlOutlet.selectedSegmentIndex == 0 {
            print("Selected: Signer")
            userSelectedType = "signer"
        }
        else{
            userSelectedType = "reviewer"
            print("Selected: Reviewer")
        }
    }
    
    //radioButtonSelect  radioButtonDeSelect
  /*  @IBAction func signerButtonClicked(_ sender: Any) {
        
        userSelectedType = "signer"
        signerButton.setImage(UIImage(named: "radioButtonSelect"), for: UIControl.State.normal)
        reviewerButton.setImage(UIImage(named: "radioButtonDeSelect"), for: UIControl.State.normal)
    }
    
    @IBAction func reviewerButtonClicked(_ sender: Any) {
        
        userSelectedType = "reviewer"
        reviewerButton.setImage(UIImage(named: "radioButtonSelect"), for: UIControl.State.normal)
        signerButton.setImage(UIImage(named: "radioButtonDeSelect"), for: UIControl.State.normal)
    } */
    
    @objc func dismissCurrentVC(){
            print("clicked")
           
           self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addUserButtonClicked(_ sender: Any) {
        
        print("Selected User Type is: \(userSelectedType)")
        
        if userSelectedType == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please select the  user type", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if signersAndReviewersListArray.contains(userNameArray[selectedIndex]) {
                print("User Is Already Selected/Present ")
                
                let alert = UIAlertController(title: "Error", message: "This user is already selected, please select another user", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                print("New User is Selected ")
                delegate.dataPassing(userName: userNameArray[selectedIndex] , userEmail: userEmailArray[selectedIndex], userType: userSelectedType)
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
   
    /*  func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 50))
        navBar.barTintColor = UIColor(rgb: 0x347ABF)
        navBar.tintColor = UIColor.white
        
        let navItem = UINavigationItem(title: "Select user")
        let doneItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancel))
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }

    @objc func Cancel() { //dimiss current VC
      self.dismiss(animated: true, completion: nil)
    } */
    
   

}

extension SearchAndSelectUserVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultUsersTableViewCell", for: indexPath) as! SearchResultUsersTableViewCell
        
        cell.userNameLabel.text = userNameArray[indexPath.row]
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        selectedIndex = indexPath.row
       // delegate.dataPassing(userName: userNameArray[indexPath.row] , userEmail: userEmailArray[indexPath.row])
    }
}


/* extension UIColor {

    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }

    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
} */

//Removing more than one elements from Array
//https://stackoverflow.com/questions/39974838/swift-3-array-remove-more-than-one-item-at-once-with-removeat-i
