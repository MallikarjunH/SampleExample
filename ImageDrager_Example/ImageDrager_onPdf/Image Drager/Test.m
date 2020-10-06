//
//  Test.m
//  Image Drager
//
//  Created by Mallikarjun on 05/10/20.
//  Copyright © 2020 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>

//
//  ViewController.m
//  Image Drager
//
//  Created by Nikita on 30/09/20.
//  Copyright © 2020 Nikita. All rights reserved.
//


// #import "ViewController.h"
////#import "MBProgressHUD.h"
//
//@interface ViewController ()
//{
//    UIImageView * imageview;
//    CGRect frame;
//    int current; // currently visible page
//}
//@end
//
//@implementation ViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//   // CGRect myImageRect = CGRectMake(100, 100, 200, 35);
//    CGRect myImageRect = CGRectMake(10, 10, 200, 35);
//    self->imageview = [[UIImageView alloc] initWithFrame:myImageRect];
//    [self->imageview setImage:[UIImage imageNamed:@"signer"]];
//  //  [self.view addSubview:self->imageview];
//    [self.pdfView addSubview:self->imageview];
//
//    self->imageview.userInteractionEnabled = YES;
//}
//
//- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
//       UITouch *touch = [[event allTouches] anyObject];
//       CGPoint touchLocation = [touch locationInView:self.pdfView];
//       self->imageview.center = touchLocation;
//
//      frame = [self.view convertRect:self->imageview.frame fromView:self.pdfView];
//      NSLog(@"touchesMoved %@", CGRectCreateDictionaryRepresentation(frame));
//
//}
//
///*- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
//    UITouch *touch = [[event allTouches] anyObject];
//    //CGPoint touchLocation = [touch locationInView:touch.view];
//    CGPoint touchLocation = [touch locationInView:touch.view];
//
//    //CGRect frame = [firstView convertRect:buttons.frame fromView:secondView];
//    frame = [self.view convertRect:self->imageview.frame fromView:self.pdfView];
//    NSLog(@"touchesMoved %@", CGRectCreateDictionaryRepresentation(frame));
//
//    if ([touch.view isEqual: self.view]) {
//
//        self->imageview.center = touchLocation;
//
//        return;
//    }
//}*/
//
//
//- (void) viewDidAppear: (BOOL)animated
//{
//    [super viewDidAppear:animated];
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//
//    [self preparePDFViewWithPageMode:kPDFDisplaySinglePage];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PDFViewAnnotationHitNotification:) name:PDFViewAnnotationHitNotification object:self.pdfView];
//
//   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PDFViewPageChangedNotification:) name:PDFViewPageChangedNotification object:self.MainpdfView];
//
//}
//
//#pragma mark - PDFViewAnnotationHitNotification
//
//-(void)PDFViewAnnotationHitNotification:(NSNotification*)notification {
//    PDFAnnotation *annotation = (PDFAnnotation*)notification.userInfo[@"PDFAnnotationHit"];
//    NSUInteger pageNumber = [self.pdfDocument indexForPage:annotation.destination.page];
//    NSLog(@"Page: %lu", (unsigned long)pageNumber);
//}
//
///*
//-(void)PDFViewPageChangedNotification:(NSNotification*)notification{
//
//    NSLog(@"%@",[NSString stringWithFormat:@"Page %@ of %lu", self.MainpdfView.currentPage.label, (unsigned long)self.pdfDocument.pageCount]);
//
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.MainpdfView animated:YES];
//
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = [NSString stringWithFormat:@"Page %@ of %lu", self.MainpdfView.currentPage.label, (unsigned long)self.pdfDocument.pageCount];
//    hud.margin = 10.f;
//    hud.yOffset = 170;
//    hud.removeFromSuperViewOnHide = YES;
//
//    [hud hide:YES afterDelay:0.3];
//
//} */
//
//
//- (void)preparePDFViewWithPageMode:(PDFDisplayMode) displayMode {
//
//   // NSString * pdfImagedetail = @"";
//    //Using base64 data
//  //  NSData *data = [[NSData alloc]initWithBase64EncodedString:pdfImagedetail options:0];
//  //  self.pdfDocument = [[PDFDocument alloc] initWithData:data];
//
//    //using local file
//    NSURL * URL = [[NSBundle mainBundle] URLForResource: @"appointment-letter" withExtension: @"pdf"];
//    self.pdfDocument = [[PDFDocument alloc] initWithURL: URL];
//
//
//    self.pdfView.displaysPageBreaks = NO;
//    self.pdfView.autoScales = YES;
//    self.pdfView.maxScaleFactor = 4.0;
//    self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit;
//
//    //load the document
//    self.pdfView.document = self.pdfDocument;
//
//    //set the display mode
//    self.pdfView.displayMode = displayMode;
//
//    self.pdfView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
//    self.pdfView.displayDirection = kPDFDisplayDirectionHorizontal;
//    [self.pdfView zoomIn:self];
//    self.pdfView.autoScales = true;
//    self.pdfView.backgroundColor = [UIColor  whiteColor];
//
//
//    self.pdfView.document = self.pdfDocument;
//
//  //  CGContextRef context = UIGraphicsGetCurrentContext();
//  //  CGRect signatureFieldBounds = CGRectMake(300, 350, 100, 30);
//    [self.pdfView usePageViewController:(displayMode == kPDFDisplaySinglePage) ? YES :NO withViewOptions:nil];
//
//    NSLog(@"Current Page is: %lu",(unsigned long)[self.pdfDocument indexForPage:self.pdfView.currentPage] );
//    [self.pdfView bringSubviewToFront:self->imageview];
//}
//
//@end
//
//
