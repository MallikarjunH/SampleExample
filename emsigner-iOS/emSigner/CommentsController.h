//
//  CommentsController.h
//  emSigner
//
//  Created by EMUDHRA on 14/08/19.
//  Copyright © 2019 Emudhra. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentsController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *commentsTableview;

@property (weak, nonatomic) IBOutlet UILabel *selectedDocumentLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (weak, nonatomic) IBOutlet UIImageView *atachmentImg;
@property (weak, nonatomic) IBOutlet UILabel *atchmentTitleLbl;

@property (nonatomic, strong) NSString *workflowID;
@property (strong,nonatomic) NSMutableArray * documentNamesArray;
@property (strong,nonatomic) NSMutableArray * getDcommentsArray;
@property (nonatomic, strong) NSString *documentID;

@property (weak, nonatomic) IBOutlet UIButton *postButton;

@end

NS_ASSUME_NONNULL_END
