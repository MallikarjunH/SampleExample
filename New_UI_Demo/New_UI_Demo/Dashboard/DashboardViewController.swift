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
        cell.typeImg.image = UIImage(named: categoryImgArray[indexPath.item])
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Clicked on: %d", indexPath.item)
       
      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
      let detailsVC = storyBoard.instantiateViewController(withIdentifier: "DocStoreViewController") as! DocStoreViewController
      self.navigationController?.pushViewController(detailsVC, animated: true)
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
        return UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    }
    
    
    
    
}
