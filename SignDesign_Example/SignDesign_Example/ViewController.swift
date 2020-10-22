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
    
    let thumbnailDimension = 44
    let animationDuration: TimeInterval = 0.25
    let sidebarBackgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    
    var signGridListCount = 0
    var signersAndReviewersListArray:[String] = []
    
    var imageview: UIImageView? = nil
    var frame: CGRect?
    
    var pdfXPosition:CGFloat = 5.0//0.0
    var pdfYPosition:CGFloat = 95.0//88.0
    
    var  customView1:SignatoryXibView?
    var  customView2:SignatoryXibView?
    var  customView3:SignatoryXibView?
    
    var  customView4:SignatoryXibView?
    var  customView5:SignatoryXibView?
    var  customView6:SignatoryXibView?
    
    var currentIndexOfTableView = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        print("screenSize: \(screenSize), screenWidth:\(screenWidth), screenHeight:\(screenHeight)")
        
        customView1 = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        customView2 = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        customView3 = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        customView4 = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        customView5 = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        customView6 = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        
        loadPdf()
        
        self.pdfView.addSubview(signerListTableView)
        self.pdfView.addSubview(toggleBtn)
        
        self.updateUserGridListTableView()
        
        setupThumbnailView()
        toggleSidebar()
        
        
        /*  let thumbnailView = PDFThumbnailView()
         thumbnailView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(thumbnailView)
         
         thumbnailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
         thumbnailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
         thumbnailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
         
         pdfView.bottomAnchor.constraint(equalTo: thumbnailView.topAnchor).isActive = true
         thumbnailView.heightAnchor.constraint(equalToConstant: 120).isActive = true
         
         thumbnailView.thumbnailSize = CGSize(width: 100, height: 100)
         thumbnailView.layoutMode = .horizontal
         
         thumbnailView.pdfView = pdfView */
        
        //Add Annotation - Test
       /* let rect = CGRect(x: 30, y: 30, width: 30, height: 30)
        
             let attr:[PDFAnnotationKey:Any] = [.color: UIColor.yellow,
                                                .border: self.pdfAnnotationBorder]
        
             let annotation = PDFAnnotation(bounds: rect, forType: .text, withProperties: attr)
        
         pdfView.currentPage?.addAnnotation(annotation) */
    }
    
    //Add Annotation - Test
   /* private var pdfAnnotationBorder:PDFBorder {
        let border = PDFBorder()
        border.lineWidth = 4.0
        border.style = .solid
        return border
    } */

    
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
                
                //Testing
                let origin = self.pdfView.superview?.convert(self.pdfView.frame.origin, to: nil)
                let pdfFrameSize = self.pdfView.frame.size
                let width = self.pdfView.frame.size.width
                let height = self.pdfView.frame.size.height
                
                print("PDF View Position: \(String(describing: origin))")
                print("PDF Height : \(height) and width: \(width) and Pdf FrameSize: \(pdfFrameSize)")
            
                //self.pdfView.bringSubviewToFront(customView1!)
            
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePageChange(notification:)),
            name: Notification.Name.PDFViewPageChanged,
            object: self.pdfView)
        
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
        
        let pageHud = MBProgressHUD.showAdded(to: self.pdfView, animated: true)
        pageHud.mode = .text
        pageHud.label.text = "Page \(self.pdfView.currentPage!.label!) of \(self.pdfView.document!.pageCount)"
        pageHud.margin = 10.0
        pageHud.offset.y = 170
        pageHud.removeFromSuperViewOnHide = true
        pageHud.hide(animated: true, afterDelay: 1.0)
        
        print("Page \(self.pdfView.currentPage!.label!) of \(self.pdfView.document!.pageCount)")
        
        if currentPageNumberOfPdf == 1 {
            
        }
        else if currentPageNumberOfPdf == 2 {
            // self.pdfView.addSubview(customView2!)
        }
        else if currentPageNumberOfPdf == 3 {
            
        }
        else if currentPageNumberOfPdf == 4 {
            
        }
        else if currentPageNumberOfPdf == 5 {
            
        }
        else{
            print("Page number is more than 5")
        }
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
    
    func dataPassing(userName: String, userEmail: String) {
        
        print("Selected User : \(userName) \(userEmail)")
        
        signersAndReviewersListArray.append(userName)
        signGridListCount = signGridListCount + 1
        
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        let touch = touches.first
        let touchLocation = touch?.location(in: self.pdfView)
        
        if currentPageNumberOfPdf == 1{
            
            if currentIndexOfTableView == 0 {
                frame = view.convert(customView1!.frame, from: pdfView)
                print("Touches Ended \(frame!.dictionaryRepresentation)")
               
                //print("x position: \(frame?.origin.x)")
                //print("x position: \(frame?.origin.y)")
                //Not Required - Need to be chnaged - Tesing
                customView1?.center = touchLocation!
                  
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch?.location(in: self.pdfView)
       // customView1?.center =  touchLocation!
       
        if currentPageNumberOfPdf == 1{
            
            if currentIndexOfTableView == 0 {
                frame = view.convert(customView1!.frame, from: pdfView)
                print("touchesMoved \(frame!.dictionaryRepresentation)")
               
                if frame!.origin.x < pdfXPosition {
                    //touchesCancelled(touches, with: event)
                }
                else if frame!.origin.y < pdfYPosition {
                    //touchesCancelled(touches, with: event)
                }
                else{
                    customView1?.center = touchLocation!
                    return
                }
                //customView1?.center = touchLocation!
               // return
            }
            else if currentIndexOfTableView == 1 {
                customView2?.center = touchLocation!
                return
            }
            else if currentIndexOfTableView == 2 {
                customView3?.center = touchLocation!
                return
            }
        
        }
        else if currentPageNumberOfPdf == 2{
            
            if currentIndexOfTableView == 0 {
               customView4?.center = touchLocation!
                return
            }
            else if currentIndexOfTableView == 1 {
                customView5?.center = touchLocation!
                return
            }
            else if currentIndexOfTableView == 2 {
                customView6?.center = touchLocation!
                return
            }
        
        }
        
      //  frame = view.convert(customView1!.frame, from: pdfView)
      //  print("touchesMoved \(frame!.dictionaryRepresentation)")

    }
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return signGridListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignGridListTableViewCell", for: indexPath) as! SignGridListTableViewCell
        
        cell.signLabel.text = "Sign \(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        currentIndexOfTableView = indexPath.row
        
        if currentPageNumberOfPdf == 1 {
            if indexPath.row == 0 {
                customView1?.signatoryLabel.text = signersAndReviewersListArray[0]
                self.pdfView.addSubview(customView1!)
            }
            else if indexPath.row == 1 {
                customView2?.signatoryLabel.text = signersAndReviewersListArray[1]
                self.pdfView.addSubview(customView2!)
            }
            else if indexPath.row == 2 {
                customView3?.signatoryLabel.text = signersAndReviewersListArray[2]
                self.pdfView.addSubview(customView3!)
            }
        }
        else if currentPageNumberOfPdf == 2 {
            
            if indexPath.row == 0 {
                self.pdfView.addSubview(customView4!)
            }
            else if indexPath.row == 1 {
                self.pdfView.addSubview(customView5!)
            }
            else if indexPath.row == 2 {
                self.pdfView.addSubview(customView6!)
            }
        }
        else if currentPageNumberOfPdf == 3 {
            
        }
        else{
            print("Page number is more than 3")
        }
    }
    
}

