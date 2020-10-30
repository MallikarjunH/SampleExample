//
//  ViewController.swift
//  SignDesign_Example
//
//  Created by Mallikarjun on 19/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit
import PDFKit
import QuartzCore
import MBProgressHUD

class ViewController: UIViewController, SendSelectedUserData {
    
    @IBOutlet weak var pdfView: PDFView!
    
    @IBOutlet weak var pdfThumbnailView: PDFThumbnailView!
    @IBOutlet weak var signerListTableView: UITableView!
    
    @IBOutlet weak var toggleBtn: UIButton!
    @IBOutlet weak var sidebarLeadingConstraint: NSLayoutConstraint!
    
    var currentPageNumberOfPdf = 0
    var totalPageOfPdf = 0
    
    let thumbnailDimension = 44
    let animationDuration: TimeInterval = 0.25
    let sidebarBackgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    
    var signGridListCount = 0
    var signersAndReviewersListArray:[String] = []
    var userTypeArray:[String] = []
    var userEmailArray:[String] = []
    
    var imageview: UIImageView? = nil
    var frame: CGRect?
    
    var currentIndexOfTableView = 0

    var signatoryViewArray: [SignatoryXibView] = []
    var signatoryViewArray2: [SignatoryXibView] = []
    
    var signatoryViewCollectionArray:[[SignatoryXibView]] = [] //Stores Signatory Placeholders frames list
    var signatoryViewEmailCollectionArray:[[String]] = [] //Stores Signatory Emails
    var signatoryViewsTagCollectionArray:[[Int]] = [] //Store Tags
    
   // var frameArray: [CGRect] = []
    
    var frameArray1: [CGRect] = []
    var frameArray2: [CGRect] = []
    
    var framesArrayWithPageNumber: [[Int:[CGRect]]] = []
    
    var firstTimeRun = "True"
    var tagValue = 0
    var currentSelectedTagValue = 0 //Testing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        signatoryViewArray.removeAll()
        signatoryViewCollectionArray.removeAll()
        signersAndReviewersListArray.removeAll() //User Name
        userTypeArray.removeAll() // User Type
        userEmailArray.removeAll() // User Email
        signatoryViewEmailCollectionArray.removeAll() //
        signatoryViewsTagCollectionArray.removeAll()
        
        loadPdf()
        
        self.pdfView.addSubview(signerListTableView)
        self.pdfView.addSubview(toggleBtn)
        
        self.updateUserGridListTableView()
        
        setupThumbnailView()
        toggleSidebar()
        
      //  self.pdfView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))


        NotificationCenter.default.addObserver(
        self,
        selector: #selector(handlePageChange(notification:)),
        name: Notification.Name.PDFViewPageChanged,
        object: self.pdfView)
        
        NotificationCenter.default.addObserver(forName:NSNotification.Name(rawValue: "getSelectedTag"), object:nil, queue:nil, using:getSelectedTagData)
    }

    func loadPdf(){
        
        if let path = Bundle.main.path(forResource: "appointment-letter", ofType: "pdf") {
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                pdfView.displayMode =  .singlePage // .singlePage //.singlePageContinuous //.twoUp
                //by default display mode is - singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical // .horizontal//.vertical
                pdfView.document = pdfDocument
            
                pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleBottomMargin]
                pdfView.zoomIn(self)
                pdfView.autoScales = true
                pdfView.backgroundColor = UIColor.white

                //Imp line
                pdfView.usePageViewController(true, withViewOptions: [:])
                
                currentPageNumberOfPdf = self.pdfView.currentPage?.pageRef?.pageNumber ?? 0
                print("Total Pages in PDF : ",pdfDocument.pageCount);
                totalPageOfPdf = pdfDocument.pageCount
                UserDefaults.standard.set(currentPageNumberOfPdf, forKey: "pageNumberKey")
                //self.pdfView.bringSubviewToFront(customView1!)
            
                var signatoryViewSubArray: [SignatoryXibView] = []
                var signatoryEmailListArray: [String] = []
                var signatoryTagListArray: [Int] = []
                
                for _ in 1...totalPageOfPdf{
                    signatoryViewCollectionArray.append(signatoryViewSubArray)
                    signatoryViewEmailCollectionArray.append(signatoryEmailListArray)
                    signatoryViewsTagCollectionArray.append(signatoryTagListArray)
                }
                
            }
        }
        
    }
    
    //signatoryViewArray
    
 /*  @objc func pan(_ gesture: UIPanGestureRecognizer) {
        
    print(frame as Any)
        //let touch = touches.first
       // let touchLocation = touch?.location(in: self.pdfView)
       
      // let touchLocation = gesture.location(in: self.pdfView)
        
        switch gesture.state {
        case .began:
            print("Gesture Begin")
            break
        case .changed:
            
            if signatoryViewArray.count > 0 {
                
                 let distance = gesture.translation(in: view)
                 let index = signatoryViewArray.index(before: signatoryViewArray.endIndex)
                 let frame = signatoryViewArray[index].frame
                // signatoryViewArray[index].frame = .init(origin: frame.origin, size: .init(width: frame.width + distance.x, height: frame.height + distance.y))
                 
                 //signatoryViewArray[index].setNeedsDisplay()
                 gesture.setTranslation(.zero, in: view)
            }
        
        case .ended:
            break
        default:
            break
        }
    } */
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let pageHud = MBProgressHUD.showAdded(to: self.pdfView, animated: true)
        pageHud.mode = .text
        pageHud.label.text = "Page \(self.pdfView.currentPage!.label!) of \(self.pdfView.document!.pageCount)"
        pageHud.margin = 10.0
        pageHud.offset.y = 170
        pageHud.removeFromSuperViewOnHide = true
        pageHud.hide(animated: true, afterDelay: 1)
        
        print("Page \(self.pdfView.currentPage!.label!) of \(self.pdfView.document!.pageCount)")
    
    }
    
    @objc private func handlePageChange(notification: Notification)
    {
        // let curPg = self.pdfView.currentPage?.pageRef?.pageNumber
        //pageNumber.stringValue = "Page \(String(describing: curPg!))"
        // print("Page \(String(describing: curPg!))")
        
       let preveousPdfPageNumber = UserDefaults.standard.integer(forKey: "pageNumberKey")
       print("Preveous page number in userDefaults: \(preveousPdfPageNumber)")
        
       currentPageNumberOfPdf = self.pdfView.currentPage?.pageRef?.pageNumber ?? 0
        if preveousPdfPageNumber == currentPageNumberOfPdf{
            return
        }
        
        let pageHud = MBProgressHUD.showAdded(to: self.pdfView, animated: true)
        pageHud.mode = .text
        pageHud.label.text = "Page \(self.pdfView.currentPage!.label!) of \(self.pdfView.document!.pageCount)"
        pageHud.margin = 10.0
        pageHud.offset.y = 170
        pageHud.removeFromSuperViewOnHide = true
        pageHud.hide(animated: true, afterDelay: 1.0)
        
        frameArray1.removeAll()
        
        if preveousPdfPageNumber == 1 {
           
            let subArray = signatoryViewCollectionArray[0]
            
            for framesIndexInPage1 in subArray{
                
                let customeView = framesIndexInPage1
                frame = self.pdfView.convert(customeView.frame, from: pdfView)
               // frameArray.append(frame!)
                let rect = CGRect(x: (frame?.origin.x)!, y: (frame?.origin.y)!, width: frame!.width, height: frame!.height)
                frameArray1.append(rect)
            }
        }
        else {
            //Save frames data
            let currenIndexForStoringDataFromCurrentPageNumber = currentPageNumberOfPdf - 1

            let subArray = signatoryViewCollectionArray[currenIndexForStoringDataFromCurrentPageNumber]
            
            for framesIndexInPage1 in subArray{
                
                let customeView = framesIndexInPage1
                frame = self.pdfView.convert(customeView.frame, from: pdfView)
               // frameArray.append(frame!)
                let rect = CGRect(x: (frame?.origin.x)!, y: (frame?.origin.y)!, width: frame!.width, height: frame!.height)
                frameArray1.append(rect)
            }
        }
        
        print("Page \(self.pdfView.currentPage!.label!) of \(self.pdfView.document!.pageCount)")
        
        //Test
        let currentPageNumber =  self.pdfView.currentPage?.pageRef?.pageNumber ?? 0
        UserDefaults.standard.set(currentPageNumber, forKey: "pageNumberKey")
    
        print("Singatory Array in Page Number Changed: \(signatoryViewArray)")
        
    
        //Display/Hide Frames
        //for pageNumber in 1...totalPageOfPdf {
        for pageNumber in 1...totalPageOfPdf {
            //pageNumber
            let currenIndexForStoringDataFromCurrentPageNumber = currentPageNumberOfPdf - 1
            let subArray = signatoryViewCollectionArray[currenIndexForStoringDataFromCurrentPageNumber]
            
            if pageNumber == currentPageNumberOfPdf {
                
                if frameArray1.count > 0 {
                    
                    for framesIndexInPage1 in subArray{
                        let index = subArray.firstIndex(of: framesIndexInPage1)
                        framesIndexInPage1.frame = frameArray1[index!]
                        self.pdfView.addSubview(framesIndexInPage1)
                    }
                }
               // signatoryViewArray[indexPath.row].signatoryLabel.text = signersAndReviewersListArray[indexPath.row]
                //self.pdfView.addSubview(signatoryViewArray[indexPath.row])
            }
            else{ //Remove Frames
                let pageNumber2 = pageNumber - 1
                for framesIndexInPage1 in signatoryViewCollectionArray[pageNumber2]{ //signatoryViewArray
                    framesIndexInPage1.removeFromSuperview()
                }
    
            }
        }
        
        print("I am in end of : handlePageChange method")
    }
    
    @IBAction func onClickMenuBtnToggle(_ sender: Any) {
        toggleSidebar()
    }
    
    func toggleSidebar() {
        let thumbnailViewWidth = pdfThumbnailView.frame.width
        let screenWidth = UIScreen.main.bounds.width
        let multiplier = thumbnailViewWidth / (screenWidth - thumbnailViewWidth) + 1.0
        let isShowing = sidebarLeadingConstraint.constant == 0
        let scaleFactor = self.pdfView.scaleFactor
        UIView.animate(withDuration: animationDuration) {
            self.sidebarLeadingConstraint.constant = isShowing ? -thumbnailViewWidth : 0
            self.pdfView.scaleFactor = isShowing ? scaleFactor * multiplier : scaleFactor / multiplier
            self.view.layoutIfNeeded()
        }
    }
    
    func setupThumbnailView() {
        pdfThumbnailView.pdfView = self.pdfView
        pdfThumbnailView.thumbnailSize = CGSize(width: thumbnailDimension, height: thumbnailDimension)
        pdfThumbnailView.backgroundColor = sidebarBackgroundColor
        pdfThumbnailView.layoutMode = .vertical
        
    }
    
    func dataPassing(userName: String, userEmail: String, userType: String) {
        
        print("Selected User : \(userName) \(userEmail) :\(userType)")
        
        signersAndReviewersListArray.append(userName)
        userEmailArray.append(userEmail)
        userTypeArray.append(userType)
        
        signGridListCount = signGridListCount + 1
        
        /*  let customView = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
         signatoryViewArray.append(customView) */
        
        updateUserGridListTableView()
        
        DispatchQueue.main.async {
            
            self.signerListTableView.reloadData()
        }
    }

    @IBAction func addSignatoryButtonClicked(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchAndSelectUserVC") as! SearchAndSelectUserVC
        vc.delegate = self
        vc.signersAndReviewersListArray = signersAndReviewersListArray
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    func updateUserGridListTableView() {
        
        if signGridListCount == 0 {
            
            DispatchQueue.main.async {
                
                self.signerListTableView.isHidden = true
                self.signerListTableView.layer.borderWidth = 0
                self.signerListTableView.layer.borderColor = UIColor.black.cgColor
            }
        }else{
            DispatchQueue.main.async {
                
                self.signerListTableView.isHidden = false
                self.signerListTableView.layer.borderWidth = 0.5
                self.signerListTableView.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    @IBAction func sendButtonClickAction(_ sender: Any) {
      print("Clicked on Send Button")
      //  let customeView = signatoryViewArray[0]
        
       // frame = view.convert(customeView.frame, from: pdfView) //view starts from main view
      //  frame = self.pdfView.convert(customeView.frame, from: pdfView) //only within PDF

      //  print("Position is:  \(frame!.dictionaryRepresentation)")
       // print(String(format: "X value is : %2.f and Y value is: %2.f", (frame?.origin.x)!, (frame?.origin.y)!))
    }
    
    func getSelectedTagData(notification:Notification) -> Void {
        guard let someTagValue:Int = notification.userInfo!["sampleDict"] as? Int else {
            return
        }
        print("I am in notification Center Method")
        print("Tag Value is: \(someTagValue)")
        
        print("Current Page of PDF: \(currentPageNumberOfPdf)")
        currentSelectedTagValue = someTagValue
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("getSelectedTag"), object: nil)
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return signGridListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignGridListTableViewCell", for: indexPath) as! SignGridListTableViewCell
        
       // cell.signLabel.text = "Sign \(indexPath.row + 1)"
        cell.signLabel.text = signersAndReviewersListArray[indexPath.row]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeSignatoryimageTapped(tapGestureRecognizer:)))
        cell.cancelImage.isUserInteractionEnabled = true
        cell.cancelImage.addGestureRecognizer(tapGestureRecognizer)
        cell.cancelImage.tag = indexPath.row
        return cell
    }
    
    @objc func removeSignatoryimageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        let tag = tapGestureRecognizer.view!.tag
        print("Selected Index of Image is: \(tag)")
        
        signersAndReviewersListArray.remove(at: tag)
        userTypeArray.remove(at: tag)
        
        let currentEmailIs = userEmailArray[tag]
        userEmailArray.remove(at: tag)
        print("Current Page is: \(currentPageNumberOfPdf)")
       
        signGridListCount = signGridListCount - 1 //It will update list from GridTableView
      
      
        //Remove/delete all emails with the current selected user
        let itemToRemove = currentEmailIs
        
        var someTestArray:[[Int]] = []
        for (index, arrayObject) in signatoryViewEmailCollectionArray.enumerated() {

            var someTestArray2:[Int] = [] //TempArray
            
            if arrayObject.contains(itemToRemove) {
                
                for emailObject in arrayObject {
                    
                    if emailObject == itemToRemove {
                        someTestArray2.append(0)
                    }
                    else{
                        someTestArray2.append(1)
                    }
                }
            }
           // print("After while loop and before for loop: \(arrayObject)")
            signatoryViewEmailCollectionArray[index] = arrayObject
            someTestArray.append(someTestArray2)
        }
        print("Final Email Array: \(signatoryViewEmailCollectionArray)")
        print("SomeTetArray: \(someTestArray)")
    
        //Remove Frames
        
        for (mainIndex,subArray) in someTestArray.enumerated() {
            
            var indexToRemove:[Int] = []
            
            for (index,number) in subArray.enumerated() {
                
                if number == 0 {
                    indexToRemove.append(index)
                }
            }
            
            print("Index to Remove: \(indexToRemove)")
            
            var someTestArray2 = signatoryViewCollectionArray[mainIndex]
           
            //Remove frames from PDF view - Remove from Superview
            let subArray1 = subArray  //[1, 0, 1, 1]
            for (index,frameToRemove) in subArray1.enumerated() {
                if frameToRemove == 0 {
                    someTestArray2[index].removeFromSuperview()
                }
            }
            
            //Remove frames from signatoryViewCollectionArray collection
            let arrayRemainingViews = someTestArray2
                .enumerated()
                .filter { !indexToRemove.contains($0.offset) }
                .map { $0.element }
            
            print("Result After Removing Views: \(arrayRemainingViews)")
            
            signatoryViewCollectionArray[mainIndex] = arrayRemainingViews
            
            //Remove Emails
            var someTestEmailArray = signatoryViewEmailCollectionArray[mainIndex]
            
            let arrayRemainingEmails = someTestEmailArray
                .enumerated()
                .filter { !indexToRemove.contains($0.offset) }
                .map { $0.element }
            
            print("Result After Removing Emails: \(arrayRemainingEmails)")
            signatoryViewEmailCollectionArray[mainIndex] = arrayRemainingEmails
        }

        print("Final 111 ViewsFrames: \(signatoryViewCollectionArray)")
        print("Final 111 Emails: \(signatoryViewEmailCollectionArray)")
        
        updateUserGridListTableView() //Update list and other updates of GridTableView
        
        DispatchQueue.main.async {
            
            self.signerListTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let signerOrReviewer = userTypeArray[indexPath.row]
        let currentSelectedUserEmail = userEmailArray[indexPath.row]
        
        if signerOrReviewer == "signer" {
            
            tagValue = tagValue + 1
           // let customView = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
            let customView = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 120, height: 60))
            customView.tag = tagValue
            
            let currenIndexForStoringDataFromCurrentPageNumber = currentPageNumberOfPdf - 1
            let indexValue = currenIndexForStoringDataFromCurrentPageNumber
            
            //adding/storing Views
            var subArray = signatoryViewCollectionArray[indexValue]
            subArray.append(customView)
            signatoryViewCollectionArray[indexValue] = subArray
            
            //adding/storing emails
            var subEmailArray = signatoryViewEmailCollectionArray[indexValue]
            subEmailArray.append(currentSelectedUserEmail)
            signatoryViewEmailCollectionArray[indexValue] = subEmailArray
            
            //adding/storing tags
            var subTagArray = signatoryViewsTagCollectionArray[indexValue]
            subTagArray.append(tagValue)
            signatoryViewsTagCollectionArray[indexValue] = subTagArray
            
            //print("Total Pages: \(totalPageOfPdf)")
            currentIndexOfTableView = indexPath.row
            
            for pageNumber in 1...totalPageOfPdf {
                //pageNumber
                if pageNumber == currentPageNumberOfPdf {
                    
                    customView.signatoryLabel.text = signersAndReviewersListArray[indexPath.row]
                    self.pdfView.addSubview(customView)
                }
            }
            
            updateUserGridListTableView()
        }
        else{
            print("Its Reviewer: No need to add")
        }

    }
    
}

