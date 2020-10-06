//
//  SignatoryView.h
//  Image Drager
//
//  Created by Mallikarjun on 01/10/20.
//  Copyright © 2020 Nikita. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignatoryView : UIView

@property (weak, nonatomic) IBOutlet UILabel *signatoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cancelButtonImgView;

@end

NS_ASSUME_NONNULL_END
