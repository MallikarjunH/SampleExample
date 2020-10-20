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
    
    let thumbnailDimension = 44
    let animationDuration: TimeInterval = 0.25
    let sidebarBackgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    
    var signGridListCount = 0
    
    
    var imageview: UIImageView? = nil
    var frame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //Signatory View
        let myImageRect = CGRect(x: 50, y: 100, width: 112, height: 58)
        imageview = UIImageView(frame: myImageRect)
        imageview?.image = UIImage(named: "signer")
        self.pdfView.addSubview(imageview!)
        imageview?.isUserInteractionEnabled = true
        
        
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
                
                print("Total Pages in PDF : ",pdfDocument.pageCount);
                
                self.pdfView.bringSubviewToFront(imageview!)
            }
        }
        
        
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
        
        signGridListCount = signGridListCount + 1
        
        updateUserGridListTableView()
        
        DispatchQueue.main.async {
            
            self.signerListTableView.reloadData()
        }
    }
    
    @IBAction func addSignatoryButtonClicked(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchAndSelectUserVC") as! SearchAndSelectUserVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        /*   signGridListCount = signGridListCount + 1
         
         updateUserGridListTableView()
         
         DispatchQueue.main.async {
         
         self.signerListTableView.reloadData()
         } */
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

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch?.location(in: self.pdfView)
        imageview?.center =  touchLocation!
       
       /* frame = view.convert(imageview!.frame, from: pdfView)
        print("touchesMoved \(frame!.dictionaryRepresentation)") */
       // return
    }
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return signGridListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignGridListTableViewCell", for: indexPath) as! SignGridListTableViewCell
        
        cell.signLabel.text = "Sign \(signGridListCount)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

