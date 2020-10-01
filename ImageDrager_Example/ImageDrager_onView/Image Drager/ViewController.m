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

    CGRect myImageRect = CGRectMake(100, 100, 200, 35);
    self->imageview = [[UIImageView alloc] initWithFrame:myImageRect];
    [self->imageview setImage:[UIImage imageNamed:@"signer"]];
    [self.view addSubview:self->imageview];
}
 

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [[event allTouches] anyObject];
    //CGPoint touchLocation = [touch locationInView:touch.view];
    CGPoint touchLocation = [touch locationInView:touch.view];

    CGRect frame = [self.view convertRect:self->imageview.frame fromView:self.view];
    NSLog(@"touchesMoved %@", CGRectCreateDictionaryRepresentation(frame));
    
    if ([touch.view isEqual: self.view]) {

        self->imageview.center = touchLocation;

        return;
    }
}

@end

