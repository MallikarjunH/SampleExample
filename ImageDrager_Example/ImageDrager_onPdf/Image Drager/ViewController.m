//
//  ViewController.m
//  Image Drager
//
//  Created by Nikita on 30/09/20.
//  Copyright © 2020 Nikita. All rights reserved.
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

   // CGRect myImageRect = CGRectMake(100, 100, 200, 35);
    CGRect myImageRect = CGRectMake(10, 10, 200, 35);
    self->imageview = [[UIImageView alloc] initWithFrame:myImageRect];
    [self->imageview setImage:[UIImage imageNamed:@"signer"]];
  //  [self.view addSubview:self->imageview];
    [self.pdfView addSubview:self->imageview];
    
    self.pdfView.userInteractionEnabled = false;


}


- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [[event allTouches] anyObject];
    //CGPoint touchLocation = [touch locationInView:touch.view];
    CGPoint touchLocation = [touch locationInView:touch.view];

    //CGRect frame = [firstView convertRect:buttons.frame fromView:secondView];
    frame = [self.view convertRect:self->imageview.frame fromView:self.pdfView];
    NSLog(@"touchesMoved %@", CGRectCreateDictionaryRepresentation(frame));
    
    if ([touch.view isEqual: self.view]) {

        self->imageview.center = touchLocation;

        return;
    }
}


- (void) viewDidAppear: (BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
 
    [self preparePDFViewWithPageMode:kPDFDisplaySinglePage];
}

- (void)preparePDFViewWithPageMode:(PDFDisplayMode) displayMode {
    
   // NSString * pdfImagedetail = @"";
    //Using base64 data
  //  NSData *data = [[NSData alloc]initWithBase64EncodedString:pdfImagedetail options:0];
  //  self.pdfDocument = [[PDFDocument alloc] initWithData:data];
    
    //using local file
    NSURL * URL = [[NSBundle mainBundle] URLForResource: @"appointment-letter" withExtension: @"pdf"];
    self.pdfDocument = [[PDFDocument alloc] initWithURL: URL];

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
    
  //  CGContextRef context = UIGraphicsGetCurrentContext();
  //  CGRect signatureFieldBounds = CGRectMake(300, 350, 100, 30);
    [self.pdfView usePageViewController:(displayMode == kPDFDisplaySinglePage) ? YES :NO withViewOptions:nil];
    
}
@end

