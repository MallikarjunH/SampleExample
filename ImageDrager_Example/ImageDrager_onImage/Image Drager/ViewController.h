//
//  ViewController.h
//  Image Drager
//
//  Created by Nikita on 30/09/20.
//  Copyright © 2020 Nikita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet PDFView *pdfView;
@property (strong, nonatomic) PDFDocument *pdfDocument;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;

@end

