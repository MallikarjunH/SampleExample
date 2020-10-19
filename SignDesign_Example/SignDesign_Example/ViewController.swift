//
//  ViewController.swift
//  SignDesign_Example
//
//  Created by Mallikarjun on 19/10/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    
    // @IBOutlet var pageNumber: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let path = Bundle.main.path(forResource: "appointment-letter", ofType: "pdf") {
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                pdfView.displayMode =  .singlePageContinuous // .singlePage //.singlePageContinuous //.twoUp
                //by default display mode is - singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical // .horizontal//.vertical
                pdfView.document = pdfDocument
                
                print("Total Pages in PDF : ",pdfDocument.pageCount);
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
    
    @objc private func handlePageChange(notification: Notification)
    {
        let curPg = self.pdfView.currentPage?.pageRef?.pageNumber
        //pageNumber.stringValue = "Page \(String(describing: curPg!))"
        print("Page \(String(describing: curPg!))")
        
    }
    
}

