//
//  ViewController.m
//  Image Drager
//
//  Created by Mallikarjun on 30/09/20.
//  Copyright © 2020 Mallikarjun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImageView * imageview;
    CGRect frame;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect myImageRect = CGRectMake(100, 100, 200, 35);
    self->imageview = [[UIImageView alloc] initWithFrame:myImageRect];
    [self->imageview setImage:[UIImage imageNamed:@"signer"]];
    [self.view addSubview:self->imageview];

}
 
//This method is use - If u select/touch anywhere in the screen that image will move

/*- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    self->imageview.center = touchLocation;

    frame = [self.view convertRect:self->imageview.frame fromView:self.view];
    NSLog(@"touchesBegan %@", CGRectCreateDictionaryRepresentation(frame));
    
    if ([touch.view isEqual: self.view] || touch.view == nil) {
        return;
    }

}
*/

//This method use - only if, if u want to drag the view only when u move that imageview and then it will change its co-ordinated

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];

    frame = [self.view convertRect:self->imageview.frame fromView:self.view];
    NSLog(@"touchesMoved %@", CGRectCreateDictionaryRepresentation(frame));
    if ([touch.view isEqual: self.view]) {

        self->imageview.center = touchLocation;

        return;
    }
}


- (void) viewDidAppear: (BOOL)animated
{
    [super viewDidAppear:animated];
   /* MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.pdfView animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [NSString stringWithFormat:@"Page %@ of %lu", self.pdfView.currentPage.label, (unsigned long)self.pdfDocument.pageCount];
    hud.margin = 10.f;
    hud.yOffset = 170;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1]; */
}

- (void)viewWillAppear:(BOOL)animated{
 
    [self preparePDFViewWithPageMode:kPDFDisplaySinglePage];
}

- (void)preparePDFViewWithPageMode:(PDFDisplayMode) displayMode {
    
    NSString * pdfImagedetail = @"";
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:pdfImagedetail options:0];
    
    self.pdfDocument = [[PDFDocument alloc] initWithData:data];
    
    self.pdfView.displaysPageBreaks = NO;
    self.pdfView.autoScales = YES;
    self.pdfView.maxScaleFactor = 4.0;
    self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit;
    
    //load the document
    self.pdfView.document = self.pdfDocument;
    
    //set the display mode
    self.pdfView.displayMode = displayMode;
    
    self.pdfView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.pdfView.displayDirection = kPDFDisplayDirectionHorizontal;
    [self.pdfView zoomIn:self];
    self.pdfView.autoScales = true;
    self.pdfView.backgroundColor = [UIColor  whiteColor];
    
    
    self.pdfView.document = self.pdfDocument;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect signatureFieldBounds = CGRectMake(300, 350, 100, 30);
    [self.pdfView usePageViewController:(displayMode == kPDFDisplaySinglePage) ? YES :NO withViewOptions:nil];
    
}
@end

