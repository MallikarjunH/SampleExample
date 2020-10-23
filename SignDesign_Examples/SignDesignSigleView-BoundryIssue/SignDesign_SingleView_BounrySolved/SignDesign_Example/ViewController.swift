//
//  ViewController.swift
//  SignDesign_Example
//
//  Created by Nikita on 19/10/20.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import PDFKit
import QuartzCore
import MBProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    

    var signGridListCount = 0
    var currentPageNumberOfPdf = 0
    
    var frame: CGRect?
    
    var  customView1:SignatoryXibView?
    var  customView2:SignatoryXibView?
    var  customView3:SignatoryXibView?
    
    var  customView4:SignatoryXibView?
    var  customView5:SignatoryXibView?

    var signatoryCount = 0
    
    
    var pdfXPosition:CGFloat = 0.0 // X Axis
    var pdfYPosition:CGFloat = 88.0 // Y - View From NavigationBar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        customView1 = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        customView2 = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        customView3 = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        customView4 = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        customView5 = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        
        loadPdf()
    
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
                
               // self.pdfView.bringSubviewToFront(customView1!)
                
                //Testing
                let origin = self.pdfView.superview?.convert(self.pdfView.frame.origin, to: nil)
                let pdfFrameSize = self.pdfView.frame.size
                let width = self.pdfView.frame.size.width
                let height = self.pdfView.frame.size.height
                
                print("PDF View Position: \(String(describing: origin))")
                print("PDF Height : \(height) and width: \(width) and Pdf FrameSize: \(pdfFrameSize)")
                
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
    
        let pageHud = MBProgressHUD.showAdded(to: self.pdfView, animated: true)
        pageHud.mode = .text
        pageHud.label.text = "Page \(self.pdfView.currentPage!.label!) of \(self.pdfView.document!.pageCount)"
        pageHud.margin = 10.0
        pageHud.offset.y = 170
        pageHud.removeFromSuperViewOnHide = true
        pageHud.hide(animated: true, afterDelay: 1.0)
        
        print("Page \(self.pdfView.currentPage!.label!) of \(self.pdfView.document!.pageCount)")
    
    }

    @IBAction func addSignatoryButtonClicked(_ sender: Any) {
        
        signatoryCount = signatoryCount + 1
        
        if signatoryCount == 1 {
            customView1?.signatoryLabel.text = "Signatory \(signatoryCount)"
            self.pdfView.addSubview(customView1!)
        }
        else  if signatoryCount == 2 {
            customView2?.signatoryLabel.text = "Signatory \(signatoryCount)"
            self.pdfView.addSubview(customView2!)
        }
        else  if signatoryCount == 3 {
            customView3?.signatoryLabel.text = "Signatory \(signatoryCount)"
            self.pdfView.addSubview(customView3!)
        }
        else  if signatoryCount == 4 {
            customView4?.signatoryLabel.text = "Signatory \(signatoryCount)"
            self.pdfView.addSubview(customView4!)
        }
        else  if signatoryCount == 5 {
            customView5?.signatoryLabel.text = "Signatory \(signatoryCount)"
            self.pdfView.addSubview(customView5!)
        }
    }
    

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch?.location(in: self.pdfView)
       // customView1?.center =  touchLocation!
       
        
        if signatoryCount == 1 {
            frame = view.convert(customView1!.frame, from: pdfView)
            print("touchesMoved \(frame!.dictionaryRepresentation)")
           // customView1?.center = touchLocation!
            
            let minX = frame!.width/2
            let minY = frame!.height/2
            let maxX = pdfView.frame.width-minX
            let maxY = pdfView.frame.height-minY
            customView1?.center = CGPoint(
                x: min(maxX, max(minX, touchLocation!.x)),
                y: min(maxY ,max(minY, touchLocation!.y)))
           /* let halfWidth = frame!.width/2
            let halfHeight = frame!.height/2
            customView1!.center = CGPoint(
                x: min(pdfView.frame.width-halfWidth,
                   max(halfWidth, touchLocation!.x)),
                y: min(pdfView.frame.height-halfHeight,
                   max(halfHeight, touchLocation!.y))) */
            return
        }
        else  if signatoryCount == 2 {
            frame = view.convert(customView2!.frame, from: pdfView)
            print("touchesMoved \(frame!.dictionaryRepresentation)")
            customView2?.center = touchLocation!
            return
        }
        else  if signatoryCount == 3 {
            frame = view.convert(customView3!.frame, from: pdfView)
            print("touchesMoved \(frame!.dictionaryRepresentation)")
            customView3?.center = touchLocation!
            return
        }
        else  if signatoryCount == 4 {
            customView4?.center = touchLocation!
            return
        }
        else  if signatoryCount == 5 {
           customView5?.center = touchLocation!
           return
        }
    
       // frame = view.convert(customView1!.frame, from: pdfView)
       // print("touchesMoved \(frame!.dictionaryRepresentation)")
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
         if signatoryCount == 1 {
            
            frame = view.convert(customView1!.frame, from: pdfView)
            print("Touches Ended \(frame!.dictionaryRepresentation)")
        }
        else if signatoryCount == 2 {
            
            frame = view.convert(customView2!.frame, from: pdfView)
            print("Touches Ended \(frame!.dictionaryRepresentation)")
        }
    }
    
}


