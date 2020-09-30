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

@end

