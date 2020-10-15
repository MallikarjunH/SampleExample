//
//  DashboardViewController.swift
//  New_UI_Demo
//
//  Created by Mallikarjun on 16/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var categoryNameArray = ["My Signatures", "Waiting For Others", "Declined","Recalled","Completed"]
    
    var categoryImgArray = ["pending","waitingForOthers","declined","recalled","completed"]
    
    var countArray = ["34", "87", "50", "14", "242"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Dashbaord"
    }
    
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionViewCell", for: indexPath) as! DashboardCollectionViewCell
        
        cell.typeName.text = categoryNameArray[indexPath.item]
        cell.countLabel.text = countArray[indexPath.item]
        cell.typeImg.image = UIImage(named: categoryImgArray[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Clicked on: %d", indexPath.item)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if indexPath.item == 0 { //MySignatures

            let detailsVC = storyBoard.instantiateViewController(withIdentifier: "MySignaturesViewController") as! MySignaturesViewController
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        else if indexPath.item == 1 { //Waiting For Others
        
            let detailsVC = storyBoard.instantiateViewController(withIdentifier: "WaitingForOthersViewController") as! WaitingForOthersViewController
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        else if indexPath.item == 2 { // Recalled
        
            let detailsVC = storyBoard.instantiateViewController(withIdentifier: "RecalledViewController") as! RecalledViewController
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        else if indexPath.item == 3 { // Declined
        
            let detailsVC = storyBoard.instantiateViewController(withIdentifier: "DeclinedViewController") as! DeclinedViewController
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        else if indexPath.item == 4 { // Completed 
        
            let detailsVC = storyBoard.instantiateViewController(withIdentifier: "CompletedViewController") as! CompletedViewController
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width - 40
        
        cellSize = CGSize(width: screenWidth / 3.0, height: 125)
        
        return cellSize
        
        //return CGSize(width: collectionView.frame.width / 3, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //return UIEdgeInsets(top: 10, left: 13, bottom: 10, right: 13)
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    
    
    
}
