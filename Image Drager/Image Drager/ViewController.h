//
//  ViewController.h
//  Image Drager
//
//  Created by Mallikarjun on 30/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet PDFView *pdfView;
@property (strong, nonatomic) PDFDocument *pdfDocument;

@end

