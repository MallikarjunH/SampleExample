//
//  AttachedMultiplePdfTableViewCell.h
//  emSigner
//
//  Created by Administrator on 7/4/17.
//  Copyright © 2017 Emudhra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachedMultiplePdfTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIImageView *pdfImage;
@property (weak, nonatomic) IBOutlet UIButton *threedotsImageBtn;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOfPages;
@property (weak, nonatomic) IBOutlet UILabel *uploadedByNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadedTimeLabel;

@end
