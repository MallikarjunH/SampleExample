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
    var signatoryCount = 0
    
    var signatoryViewArray: [SignatoryXibView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
//        self.pdfView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
        
        loadPdf()
    
    }
    
//    @objc func pan(_ gesture: UIPanGestureRecognizer) {
//
//        //let touch = touches.first
//       // let touchLocation = touch?.location(in: self.pdfView)
//
//      //  let touchLocation = gesture.location(in: self.pdfView)
//
//        switch gesture.state {
//        case .began:
//            print("Gesture Begin")
//            break
//        case .changed:
//            let distance = gesture.translation(in: view)
//            let index = signatoryViewArray.index(before: signatoryViewArray.endIndex)
//            let frame = signatoryViewArray[index].frame
//            signatoryViewArray[index].frame = .init(origin: frame.origin, size: .init(width: frame.width + distance.x, height: frame.height + distance.y))
//
//            signatoryViewArray[index].setNeedsDisplay()
//
//           /* let minX = frame.width/2
//                       let minY = frame.height/2
//                       let maxX = pdfView.frame.width-minX
//                       let maxY = pdfView.frame.height-minY
//                       signatoryViewArray[index].center = CGPoint(
//                           x: min(maxX, max(minX, touchLocation.x)),
//                           y: min(maxY ,max(minY, touchLocation.y))) */
//
//            gesture.setTranslation(.zero, in: view)
//
//        case .ended:
//            break
//        default:
//            break
//        }
//    }
    
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
        
        let index  = signatoryCount - 1
        
        let customView = SignatoryXibView(frame: CGRect(x: 30, y: 30, width: 112, height: 58))
        signatoryViewArray.append(customView)
        
        signatoryViewArray[index].signatoryLabel.text = "Signatory \(signatoryCount)"
        self.pdfView.addSubview(signatoryViewArray[index])
        
    }
    

    //Old Code
 /*   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch?.location(in: self.pdfView)
       // customView1?.center =  touchLocation!
       
        
        if signatoryCount == 1 {
            customView1?.center = touchLocation!
            return
        }
        else  if signatoryCount == 2 {
            customView2?.center = touchLocation!
            return
        }
        else  if signatoryCount == 3 {
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
    
    } */
    
}


