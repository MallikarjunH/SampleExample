//
//  AttachedVC.m
//  emSigner
//
//  Created by Administrator on 7/16/17.
//  Copyright © 2017 Emudhra. All rights reserved.
//

#import "AttachedVC.h"
#import "MBProgressHUD.h"
#import "NSObject+Activity.h"
#import "WebserviceManager.h"
#import "HoursConstants.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "AttachedViewVC.h"
#import "UploadDocuments.h"
#import "NSString+DateAsAppleTime.h"
#import "LMNavigationController.h"
#import "GlobalVariables.h"


@interface AttachedVC ()
{
    int currentPreviewIndex;
    NSString *descriptionStr;
    BOOL hasPresentedAlert;
    int currentPage;
    NSString *dateCategoryString;
    NSString *meta;
    NSURL * PDFUrl;
    NSString * UploadType;
    NSMutableArray *arrImg;
    PDFDocument *pdfDocument;
    NSString * base64String;
    NSURL *refURL;
   // NSDictionary * attachedDict;
    NSDateFormatter *formatter;
    
    
}

@property (nonatomic, weak) NSIndexPath *selectedIndexPath;
@end

@implementation AttachedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.topItem.title = @" ";
    
    _attachedToolBar.hidden = YES;
    
   // [_uploadAttachment setTitle:@"Add Attachments" forState:UIControlStateNormal];
    //[_uploadAttachment setTitle:@"Send Attachments" forState:UIControlStateNormal];
    // _isAttached = false;
    
    /*   if (_isAttached == true){
     //elf.descText.hidden = false;
     [_uploadAttachment setTitle:@"Send Attachments" forState:UIControlStateNormal];
     } else {
     //self.descText.hidden = true;
     [_uploadAttachment setTitle:@"Add Attachments" forState:UIControlStateNormal];
     } */
    
    _threeDotsArray = [[NSMutableArray alloc]init];
    _addFile = [[NSMutableArray alloc] init];
    _listArray = [[NSMutableArray alloc]init];
    formatter = [[NSDateFormatter alloc] init];
 
    
    //Empty cell keep blank
    self.attachedTableView.contentInset = UIEdgeInsetsMake(0, 0, 65, 0);
    
    [self.attachedTableView setContentOffset:CGPointMake(0.0, self.attachedTableView.tableHeaderView.frame.size.height) animated:YES];
    _attachedTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.attachedTableView registerNib:[UINib nibWithNibName:@"AttachedMultiplePdfTableViewCell" bundle:nil] forCellReuseIdentifier:@"AttachedPdfTableViewCell"];
    
    // Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1.0];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.attachedTableView addSubview:refreshControl];
    
    // Navigation Bar - Button Code
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:96.0/255.0 blue:192.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    //Left Button - Back Button
    UIView *navigationview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 47)];
    [navigationview setBackgroundColor:[UIColor colorWithRed:37.0/255.0 green:118.0/255.0 blue:200.0/255.0 alpha:1.0]];
    
    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 8, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"ico-back-24"] forState:UIControlStateNormal];
    [leftBtn setTag:1];
    [leftBtn addTarget:self action:@selector(navigationbtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [navigationview addSubview:leftBtn];
    
    //title
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width / 2) - 60, 8, 140, 30)];
    title.text = @"Attachments";
    [title textAlignment];
    [title setFont:[UIFont boldSystemFontOfSize:18]];
    title.textColor = UIColor.whiteColor;
    [navigationview addSubview:title];
    
    //Right BUtton
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 58, 8, 50, 30)];
     [rightBtn setImage:[UIImage imageNamed:@"plusWhiteIcon"] forState:UIControlStateNormal];
     // [rightBtn setTitle:@"Send" forState:UIControlStateNormal];
     [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
     [rightBtn setTag:2];
     [rightBtn addTarget:self action:@selector(addbtnTapped:) forControlEvents:UIControlEventTouchUpInside];
     [navigationview addSubview:rightBtn];
    
    
    /*  if (_isDocStore == true)
     {
     
     } else {
     
     [navigationview addSubview:rightBtn];
     } */
    
    
    // Add an observer to received get attahced attchment  data
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(triggerAction:) name:@"postAttachedDictData" object:nil];
    
    
    
    //Right Btn
    /*   UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(addbtnAction:)];
     
     UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addAdhocUserForSignatories.png"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationbtnTapped:)];
     
     self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButton, doneButton, nil];*/
    
    
    /* UIButton * addBtns = [[UIButton alloc]initWithFrame:CGRectMake(50, 8, 30, 30)];
     // [rightBtn setImage:[UIImage imageNamed:@"ico-back-24"] forState:UIControlStateNormal];
     // [addBtns setTitle:@"+" forState:UIControlStateNormal];
     [addBtns setBackgroundImage:[UIImage imageNamed:@"file-plus.png"] forState:UIControlStateNormal];
     
     [addBtns setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
     [addBtns setTag:3];
     [addBtns addTarget:self action:@selector(addbtnTapped:) forControlEvents:UIControlEventTouchUpInside];
     //  [navigationview addSubview:addBtns]; */
    
    [self.navigationController.navigationBar addSubview:navigationview];
    self.uploadAttachment.hidden = false;
    
    NSLog(@"Document Value: %@", _document);
    
    //ertertgergreg
    arrImg = [[NSMutableArray alloc]init];
    
    //if ([_document isEqualToString:@"ListAttachments"]) {
    
   
   
   // [self callForUploadAttachments:self->_documentID :_documentName :self.descText.text :base64String];
    
    [self ListAttachments];
   
//    [self initiateWorkFlow];
    
    //}
    // else
    //{
    //  [self getAttachments];
    // }
    
}

#pragma mark - Notification
-(void) triggerAction:(NSNotification *) notification
{
    NSLog(@"Received Notification - Received Attachment");
    
    _attachedDict = [[NSDictionary alloc] init];
    
    NSDictionary *dict = notification.userInfo;
    _attachedDict = dict;
    
    if(dict.count > 0){
        
        _attachedDict = dict;
         NSDictionary * attachmentDict = [dict valueForKey:@"attachemtDict"];
         NSString * base64FileData = [attachmentDict valueForKey:@"Base64FileData"];
         NSString * documentName = [attachmentDict valueForKey:@"DocumentName"];
         NSString * optionalPara = [attachmentDict valueForKey:@"OptionalParam1"];
        
    
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){

            @synchronized(self) {
                
                dispatch_async(dispatch_get_main_queue(), ^(void){

                           [self callForUploadAttachments:self->_documentID :documentName :self.descText.text :base64FileData];
                });
                
               /* dispatch_async(dispatch_get_main_queue(), ^(void){

                    [self ListAttachments];
                }); */
            }
        });
        
       // [self callForUploadAttachments:self->_documentID :documentName :self.descText.text :base64FileData];
       
        
    }else{
        
        UIAlertView * alert15 =[[UIAlertView alloc ] initWithTitle:@"" message:@"Failed to attach Attachment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert15 show];
    }
    
    // NSLog(@"Attachement Dict: %@",dict);
    
    /* YourDataObject *message = [dict valueForKey:@"message"]; //attachemtDict
     if (message != nil) {
     // do stuff here with your message data
     }*/
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([self isBeingDismissed] == YES) ///presented view controller
    {
        // remove observer here
        [[NSNotificationCenter defaultCenter] removeObserver:@"postAttachedDictData"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:@"postAttachedDictData"];
}

-(void) addbtnTapped:(UIButton *)sender {
    NSLog(@"Click on Add Attachment");
    
    if ((_descText.text.length == (id)[NSNull null]) || ([_descText.text isEqualToString:@""])) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter the description" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:true completion:nil];
    } else {
        
        _isAttached = true;
           
           [[NSUserDefaults standardUserDefaults] setValue:self.descText.text forKey:@"desc"];
           
           UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
           UploadDocuments *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"UploadDocuments"];
           objTrackOrderVC.uploadAttachment = true;
           objTrackOrderVC.isDocStore = true;
           objTrackOrderVC.documentId = _documentID;
           objTrackOrderVC.post = _parametersForWorkflow;
           objTrackOrderVC.modalPresentationStyle = UIModalPresentationFullScreen;
           UINavigationController *objNavigationController = [[UINavigationController alloc]initWithRootViewController:objTrackOrderVC];
           if (@available(iOS 13.0, *)) {
                      [objNavigationController setModalPresentationStyle: UIModalPresentationFullScreen];
           }
           [self presentViewController:objNavigationController animated:true completion:nil];
           
    }
   
    /*  if (self.descText.text.length > 0) {
     
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Pick Options" preferredStyle:UIAlertControllerStyleActionSheet];
     [alert addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     
     UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
     imagePickerController.delegate = self;
     imagePickerController.navigationBar.translucent = false;
     imagePickerController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:96.0/255.0 blue:192.0/255.0 alpha:1.0];
     imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
     imagePickerController.navigationBar.tintColor = [UIColor whiteColor]; // Cancel button ~ any UITabBarButton items
     
     [self presentViewController:imagePickerController animated:YES completion:nil];
     
     }]];
     
     [alert addAction:[UIAlertAction actionWithTitle:@"Documents" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     
     UIDocumentMenuViewController *picker =  [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"com.adobe.pdf"] inMode:UIDocumentPickerModeImport];
     
     picker.delegate = self;
     //picker.allowsMultipleSelection = YES;
     
     [self presentViewController:picker animated:YES completion:nil];
     
     }]];
     
     [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
     }]];
     [alert setModalPresentationStyle:UIModalPresentationPopover];
     
     UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
     popPresenter.sourceView = sender;
     // popPresenter.sourceRect = sender.bounds; // You can set position of popover
     [self presentViewController:alert animated:TRUE completion:nil];
     }
     else{
     
     UIAlertController * alert = [UIAlertController
     alertControllerWithTitle:nil
     message:@"Description cannot be empty!"
     preferredStyle:UIAlertControllerStyleAlert];
     //Add Buttons
     UIAlertAction* yesButton = [UIAlertAction
     actionWithTitle:@"Ok"
     style:UIAlertActionStyleDefault
     handler:^(UIAlertAction * action) {
     //Handle your yes please button action here
     }];
     [alert addAction:yesButton];
     [self presentViewController:alert animated:YES completion:nil];
     return;
     }*/
    
}

- (void) navigationbtnTapped:(UIButton *)sender {
    
    NSLog(@"Tag : %ld", (long)sender.tag);
    
    if (sender.tag == 1) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LMNavigationController *objTrackOrderVC= [sb  instantiateViewControllerWithIdentifier:@"HomeNavController"];
        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:objTrackOrderVC];
        
    }
    else{
        if ([_document isEqualToString:@"ListAttachments"]) {
            
            [self initiateWorkFlow];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LMNavigationController *objTrackOrderVC= [sb  instantiateViewControllerWithIdentifier:@"HomeNavController"];
                [[[[UIApplication sharedApplication] delegate] window] setRootViewController:objTrackOrderVC];
                
            });
            
        }
    }
}

- (IBAction)sendButtonInitiateWorkFlowButtonAction:(id)sender {
    
    [self initiateWorkFlow];
}

-(void)initiateWorkFlow{
    
    [self startActivity:@""];
    //[_parametersForWorkflow setObject: [_parametersForWorkflow objectForKey: @"CategoryID"] forKey: @"TemplateId"];
    [WebserviceManager sendSyncRequestWithURLDocument:kInitiateWorkflow method:SAServiceReqestHTTPMethodPOST body:_parametersForWorkflow completionBlock:^(BOOL status, id responseValue){
        
        if (status) {
            int   issucess = [[responseValue valueForKey:@"IsSuccess"]intValue];
            
            if (issucess != 0) {
                
                NSNumber * isSuccessNumber = (NSNumber *)[responseValue valueForKey:@"IsSuccess"];
                if([isSuccessNumber boolValue] == YES)
                {
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                        
                        [self stopActivity];
                        
                        UIAlertView * alert15 =[[UIAlertView alloc ] initWithTitle:@"" message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert15 show];
                        
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        LMNavigationController *objTrackOrderVC= [sb  instantiateViewControllerWithIdentifier:@"HomeNavController"];
                        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:objTrackOrderVC];
                        
                    });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                        UIAlertController * alert = [UIAlertController
                                                     alertControllerWithTitle:@""
                                                     message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        
                        //Add Buttons
                        
                        UIAlertAction* yesButton = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                            //Handle your yes please button action here
                            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            LMNavigationController *objTrackOrderVC= [sb  instantiateViewControllerWithIdentifier:@"HomeNavController"];
                            [[[[UIApplication sharedApplication] delegate] window] setRootViewController:objTrackOrderVC];
                            
                        }];
                        
                        //Add your buttons to alert controller
                        
                        [alert addAction:yesButton];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                        [self stopActivity];
                    });
                    
                }
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self stopActivity];
                    
                    UIAlertView * alert15 =[[UIAlertView alloc ] initWithTitle:@"" message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert15 show];
                });
                
            }
            
        }
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
            [self stopActivity];
            
            UIAlertView * alert15 =[[UIAlertView alloc ] initWithTitle:@"" message:@"Failed to intitiating the workFlow." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert15 show];
        }
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //EMIOS-1108
    NSString *desc = [[NSUserDefaults standardUserDefaults] stringForKey:@"desc"];
    self.descText.text = desc;
    
    if ([_isFromWF isEqualToString:@"Y"]){
        dispatch_async(dispatch_get_main_queue(),
                       ^{
            self->_sendButtonHeightContraint.constant = 40;
            self->_sendButtonInitiateWorkFlowButtonOutlet.hidden = NO;
        });
    }else{
        dispatch_async(dispatch_get_main_queue(),
                       ^{
            self->_sendButtonHeightContraint.constant = 0;
            self->_sendButtonInitiateWorkFlowButtonOutlet.hidden = YES;
        });
    }
    
}


-(void)viewDidAppear:(BOOL)animated {
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    [UINavigationController attemptRotationToDeviceOrientation];
}

//Show All List of Uplaoded Documents
-(void)ListAttachments{
    
    //workflowid/ parentDocumentID
    //http://localhost:54976/api/ListAttachment?DocumentID=34
    [self startActivity:@"Loading..."];
    NSString *requestURL = [NSString stringWithFormat:@"%@GetWorkflowAttachments?ParentDocumentID=%@",kAttchedDocument,_documentID];
    
    [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
        
        // if(status)
        if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
            
        {
            if ([[responseValue valueForKey:@"Response"] isKindOfClass:[NSArray class]]) {
                self->_listArray= [NSMutableArray arrayWithArray:[responseValue valueForKey:@"Response"]];
            }
            
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                
                if (self->_listArray != (id)[NSNull null])
                {
                    [self->_attachedTableView reloadData];
                    [self stopActivity];
                }
                else{
                    
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"Info"
                                                 message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    //Add Buttons
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"Ok"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                        //Handle your yes please button action here
                        
                    }];
                    
                    //Add your buttons to alert controller
                    [alert addAction:yesButton];
                    //[alert addAction:noButton];
                    [self presentViewController:alert animated:YES completion:nil];
                    [self stopActivity];
                    
                }
                
                // [self stopActivity];
                
            });
            
        }
        else{
            [self stopActivity];
        }
        
    }];
    //[self stopActivity];
}


/*
 -(void)getAttachments{
 
 // http://localhost:54976/api/ListAttachment?DocumentID=34
 [self startActivity:@"Refreshing"];
 NSString *requestURL = [NSString stringWithFormat:@"%@GetAttachmentById?WorkflowID=%@",kAttchedDocument,_workFlowId];
 
 [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
 
 // if(status)
 if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
 
 {
 
 dispatch_async(dispatch_get_main_queue(),
 ^{
 
 if ([[responseValue valueForKey:@"Response"] isKindOfClass:[NSArray class]]) {
 _listArray= [NSMutableArray arrayWithArray:[responseValue valueForKey:@"Response"]];
 }
 
 if (_listArray != (id)[NSNull null])
 {
 
 [_attachedTableView reloadData];
 
 [self stopActivity];
 }
 else{
 
 UIAlertController * alert = [UIAlertController
 alertControllerWithTitle:@"Info"
 message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
 preferredStyle:UIAlertControllerStyleAlert];
 
 //Add Buttons
 
 UIAlertAction* yesButton = [UIAlertAction
 actionWithTitle:@"Ok"
 style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action) {
 //Handle your yes please button action here
 
 }];
 
 //Add your buttons to alert controller
 
 [alert addAction:yesButton];
 //[alert addAction:noButton];
 
 [self presentViewController:alert animated:YES completion:nil];
 [self stopActivity];
 
 }
 
 [self stopActivity];
 
 });
 
 }
 else{
 
 }
 
 }];
 [self stopActivity];
 
 } */

-(void)refresh:(UIRefreshControl *)refreshControl
{
   // [self viewWillAppear:YES];
    [self ListAttachments];
   // [_attachedTableView reloadData];
    [refreshControl endRefreshing];

}

//Network Connection Checks
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger numOfSections = 0;
    if ([self.listArray count]>0)
    {
        self.attachedTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        self.attachedTableView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.attachedTableView.bounds.size.width, self.attachedTableView.bounds.size.height)];
        // noDataLabel.text             = @"No documents available";
        noDataLabel.text             = @"No attachments uploaded. \nClick + to add an attachment";
        noDataLabel.numberOfLines = 0;
        noDataLabel.textColor        = [UIColor grayColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.attachedTableView.backgroundView = noDataLabel;
        self.attachedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //hide right bar button item if there is no data
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    return numOfSections;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_listArray) {
        return [_listArray count];
    }else{
        return 1;
    }
    
    /* if (_listArray) {
     return [_listArray count];
     }
     return 1; */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AttachedMultiplePdfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttachedPdfTableViewCell" forIndexPath:indexPath];
    
    NSString * attachmentName =[[AppDelegate AppDelegateInstance] strCheckNull:[NSString stringWithFormat:@"%@",[[_listArray objectAtIndex:indexPath.row] objectForKey:@"AttachmentName"]]];
    NSString * description =[[AppDelegate AppDelegateInstance] strCheckNull:[NSString stringWithFormat:@"%@",[[_listArray objectAtIndex:indexPath.row] objectForKey:@"Description"]]];
    NSString * noOfPages =[[AppDelegate AppDelegateInstance] strCheckNull:[NSString stringWithFormat:@"%@",[[_listArray objectAtIndex:indexPath.row] objectForKey:@"NoOfPages"]]];
    NSString * uploadedByName =[[AppDelegate AppDelegateInstance] strCheckNull:[NSString stringWithFormat:@"%@",[[_listArray objectAtIndex:indexPath.row] objectForKey:@"UploaderName"]]];
    NSString * fileSize =[[AppDelegate AppDelegateInstance] strCheckNull:[NSString stringWithFormat:@"%@",[[_listArray objectAtIndex:indexPath.row] objectForKey:@"FileSize"]]];
    NSString * uploadedTime =[[AppDelegate AppDelegateInstance] strCheckNull:[NSString stringWithFormat:@"%@",[[_listArray objectAtIndex:indexPath.row] objectForKey:@"UploadedDate"]]];
    
    cell.descriptionLabel.text = description;
    cell.nameLabel.text = attachmentName;
    cell.noOfPages.text =  [NSString stringWithFormat: @"Number Of Pages : %@",noOfPages];
    cell.uploadedByNameLabel.text =  uploadedByName;
    cell.fileSizeLabel.text =  [NSString stringWithFormat: @"File Size : %@ KB",fileSize];
    
    //[formatter setDateFormat:@"MM-dd-yyyy HH:mm:ss a"];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    NSDate *dates = [formatter dateFromString:uploadedTime];
    formatter.dateFormat = @"dd MMMM yyyy, HH:mm";
    
    NSString *finalDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:dates]];
    if (finalDate == (id)[NSNull null]){
        cell.uploadedTimeLabel.text = uploadedTime;
    }else{
        cell.uploadedTimeLabel.text = finalDate;
    }
    
    [cell.threedotsImageBtn addTarget:self action:@selector(threeDots:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    if(indexPath.row == _currentSelectedRow)
    {
        
        [tableView
         selectRowAtIndexPath:indexPath
         animated:TRUE
         scrollPosition:UITableViewScrollPositionNone
         ];
        
    }
    
    /*  if ([[_listArray objectAtIndex:indexPath.row] objectForKey:@"Description"] == (id)[NSNull null]) {
     
     } else {
     cell.documentNameLabel.text = [[_listArray objectAtIndex:indexPath.row] objectForKey:@"Description"];
     }
     
     cell.dateLabelOfAttachment.text = descriptionStr;
     cell.noOfPages.text = [NSString stringWithFormat: @"Number Of Pages : %@", [[_listArray objectAtIndex:indexPath.row] objectForKey:@"PageNumbers"]];
     cell.fileSize.text = [NSString stringWithFormat: @"File Size : %@ KB", [[_listArray objectAtIndex:indexPath.row] objectForKey:@"FileSize"]]; */
    //    NSString *dateFromArray = [[_listArray objectAtIndex:indexPath.row] objectForKey:@"UploadDateTime"];
    //
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    //    NSDate *dates = [formatter dateFromString:dateFromArray];
    
    //    dateCategoryString = [NSString string];
    //
    //    NSArray* date= [[[_listArray valueForKey:@"UploadDateTime"]objectAtIndex:indexPath.row] componentsSeparatedByString:@" "];
    //    NSString *transformedDate = [dateCategoryString transformedValue:dates];
    //
    //    if ([transformedDate isEqualToString:@"Today"]) {
    //       cell.dateLabelOfAttachment.text = [date objectAtIndex:1];
    //
    //    }
    //    else{
    //        cell.dateLabelOfAttachment.text = [dateCategoryString transformedValue:dates];
    //    }
    
    
    // cell.dateLabelOfAttachment.text = [dateCategoryString transformedValue:dates];
    //
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Check Document Name
    NSString *descriptionStr1;
    descriptionStr1=[[AppDelegate AppDelegateInstance] strCheckNull:[NSString stringWithFormat:@"%@",[[_listArray objectAtIndex:indexPath.row] objectForKey:@"DocumentId"]]];
    
    _documentID =descriptionStr1;
    self.selectedIndexPath = indexPath;
    
    NSNumber * isSuccessNumber = (NSNumber *)[[_listArray objectAtIndex:indexPath.row] objectForKey:@"IsDelete"];
    if ([isSuccessNumber boolValue] == YES) {
        _documentView.hidden = NO;
    }
    else{
        _documentView.hidden = YES;
    }
    
    //Network Check
    if (![self connected])
    {
        if(hasPresentedAlert == false){
            
            // not connected
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"No internet connection!"
                                         message:@"Check internet connection!"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            //Add Buttons
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Okay"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                //Handle your yes please button action here
                
            }];
            
            
            //Add your buttons to alert controller
            
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
            hasPresentedAlert = true;
        }
    } else
    {
        
        /*************************Web Service*******************************/
        
        [self startActivity:@"Loading..."];
        
        NSString *requestURL = [NSString stringWithFormat:@"%@GetDraftFileData?workFlowId=%@",kOpenPDFImage,[[_listArray objectAtIndex:indexPath.row] valueForKey:@"DocumentId"]];
        [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
            
            // if(status)
            if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
                
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //                    //Check Null String Address
                    
                    _pdfImageArray=[[AppDelegate AppDelegateInstance] strCheckNull:[NSString stringWithFormat:@"%@",[[responseValue valueForKey:@"Response"] valueForKey:@"FileData"]]];
                    //
                    
                    if (_pdfImageArray != (id)[NSNull null])
                    {
                        
                        if ([[[[_listArray objectAtIndex:indexPath.row] valueForKey:@"DocumentName"] pathExtension] isEqualToString:@"pdf"]){
                            
                            //
                            _attachedToolBar.hidden = YES;
                            AttachedViewVC *temp = [[AttachedViewVC alloc]initWithNibName:@"AttachedViewVC" bundle:nil];
                            temp.pdfImagedetail = _pdfImageArray;
                            temp.isDelete = [[[_listArray objectAtIndex:indexPath.row] objectForKey:@"IsDelete"] boolValue];
                            temp.documentID=_documentID;
                            temp.myTitle = [[_listArray objectAtIndex:indexPath.row] objectForKey:@"DocumentName"];
                            [self.navigationController pushViewController:temp animated:YES];
                            [self stopActivity];
                            
                        }
                        else{
                            _attachedToolBar.hidden = NO;
                            _documentName = [[_listArray objectAtIndex:indexPath.row] objectForKey:@"DocumentName"];
                            [self stopActivity];
                        }
                        
                    }
                    else{
                        
                        
                        UIAlertController * alert = [UIAlertController
                                                     alertControllerWithTitle:@"Info"
                                                     message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        
                        //Add Buttons
                        
                        UIAlertAction* yesButton = [UIAlertAction
                                                    actionWithTitle:@"Ok"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                            //Handle your yes please button action here
                            
                        }];
                        
                        
                        //Add your buttons to alert controller
                        
                        [alert addAction:yesButton];
                        [self presentViewController:alert animated:YES completion:nil];
                        [self stopActivity];
                    }
                });
                
            }
            else{
                //Alert at the time of no server connection
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Alert"
                                             message:@"Try again"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                //Add Buttons
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                    //Handle your yes please button action here
                    
                }];
                
                
                //Add your buttons to alert controller
                
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
                [self stopActivity];
                
            }
            
        }];
        
    }
    
}

//delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *downloadAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Download"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
        
        [self downloadAttachments:indexPath];
    }];
    downloadAction.backgroundColor = [UIColor blueColor];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
        
        [self deleteAttachments:indexPath];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    if ([[[_listArray objectAtIndex:indexPath.row] objectForKey:@"IsDelete"] boolValue] == 1) {
        return @[deleteAction,downloadAction];
        
    }
    else{
        return @[downloadAction];
    }
    
}

-(void)downloadAttachments:(NSIndexPath *)picker{
    
    _documentID = [[_listArray objectAtIndex:picker.row] objectForKey:@"DocumentID"];
    // _documentName = [[_listArray objectAtIndex:picker.row] objectForKey:@"DocumentName"];
    NSString *requestURL = [NSString stringWithFormat:@"%@GetDraftFileData?workFlowId=%@",kDownloadPdf,_documentID];
    [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
        
        // if(status)
        if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
            
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self->_addFile removeAllObjects];
                
                self->_pdfImageArray=[[AppDelegate AppDelegateInstance] strCheckNull:[NSString stringWithFormat:@"%@",[[responseValue valueForKey:@"Response"] valueForKey:@"FileData"]]];
                
                
                if (self->_pdfImageArray != (id)[NSNull null])
                {
                    int Count;
                    NSData *data = [[NSData alloc]initWithBase64EncodedString:self->_pdfImageArray options:0];
                    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                    NSString *path = [documentsDirectory stringByAppendingPathComponent:self->_documentName];
                    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
                    for (Count = 0; Count < (int)[directoryContent count]; Count++)
                    {
                        NSLog(@"File %d: %@", (Count + 1), [directoryContent objectAtIndex:Count]);
                    }
                    [self->_addFile addObject:path];
                    
                    [data writeToFile:path atomically:YES];
                    [self stopActivity];
                    QLPreviewController *previewController=[[QLPreviewController alloc]init];
                    previewController.delegate=self;
                    previewController.dataSource=self;
                    [self presentViewController:previewController animated:YES completion:nil];
                    ;
                    [previewController.navigationItem setRightBarButtonItem:nil];                            self->_attachedToolBar.hidden = YES;
                    
                }
                else{
                    return;
                }
                
                
            });
            
        }
        else{
            
        }
        
    }];
    
}



-(void) deleteAttachments:(NSIndexPath *)picker{
    
    //Handle your yes please button action here
    [self startActivity:@"Processing..."];
    NSString *requestURL = [NSString stringWithFormat:@"%@MarkAsInactive?documentId=%@&status=%@",kInactive,[[_listArray objectAtIndex:picker.row] objectForKey:@"DocumentID"],@"Attachment"];
    
    [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
        
        // if(status)
        if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
            
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                
                
                self->_inactiveArray =responseValue;
                
                if (self->_inactiveArray != (id)[NSNull null])
                {
                    // if (self.selectedIndexPath) {
                    [self->_listArray removeObjectAtIndex:picker.row];
                    // }
                    self->_attachedToolBar.hidden = YES;
                    [self->_attachedTableView reloadData];
                    
                    [self stopActivity];
                }
                else{
                    
                    
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"Info"
                                                 message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    //Add Buttons
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"Ok"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                        //Handle your yes please button action here
                        
                    }];
                    
                    
                    //Add your buttons to alert controller
                    
                    [alert addAction:yesButton];
                    [self presentViewController:alert animated:YES completion:nil];
                    [self stopActivity];
                }
                
            });
            
        }
        else{
            
            
        }
        
    }];
    
}

- (IBAction)inactiveBtn:(id)sender {
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Delete"
                                 message:@"Do you want to Delete Document?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
        //Handle your yes please button action here
        [self startActivity:@"Processing..."];
        NSString *requestURL = [NSString stringWithFormat:@"%@MarkAsInactive?documentId=%@&status=%@",kInactive,self->_documentID,@"Attachment"];
        
        [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
            
            //  if(status)
            if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
                
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                    
                    
                    self->_inactiveArray =responseValue;
                    
                    if (self->_inactiveArray != (id)[NSNull null])
                    {
                        if (self.selectedIndexPath) {
                            [self->_listArray removeObjectAtIndex:self.selectedIndexPath.row];
                        }
                        self->_attachedToolBar.hidden = YES;
                        [self->_attachedTableView reloadData];
                        
                        [self stopActivity];
                    }
                    else{
                        
                        
                        UIAlertController * alert = [UIAlertController
                                                     alertControllerWithTitle:@"Info"
                                                     message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        
                        //Add Buttons
                        
                        UIAlertAction* yesButton = [UIAlertAction
                                                    actionWithTitle:@"Ok"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                            //Handle your yes please button action here
                            
                        }];
                        
                        
                        //Add your buttons to alert controller
                        
                        [alert addAction:yesButton];
                        [self presentViewController:alert animated:YES completion:nil];
                        [self stopActivity];
                    }
                    
                    
                });
                
            }
            else{
                
                
            }
            
        }];
    }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
        //Handle your yes please button action here
        
    }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


-(void)threeDots:(UIButton*)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.attachedTableView];
    NSIndexPath *indexPath = [self.attachedTableView indexPathForRowAtPoint:buttonPosition];
    UIAlertController * view=   [[UIAlertController
                                  alloc]init];
    UIAlertAction* Download = [UIAlertAction
                               actionWithTitle:@"Download Document"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
        
        //CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.attachedTableView];
        // NSIndexPath *indexPath = [self.attachedTableView indexPathForRowAtPoint:buttonPosition];
        self->_documentID = [[self->_listArray objectAtIndex:indexPath.row] objectForKey:@"DocumentId"];
        self->_documentName = [[_listArray objectAtIndex:indexPath.row] objectForKey:@"DocumentName"];
        NSString *requestURL = [NSString stringWithFormat:@"%@GetDraftFileData?workFlowId=%@",kDownloadPdf,self->_documentID];
        [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
            
            // if(status)
            if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
                
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self->_addFile removeAllObjects];
                    
                    self->_pdfImageArray=[[AppDelegate AppDelegateInstance] strCheckNull:[NSString stringWithFormat:@"%@",[[responseValue valueForKey:@"Response"] valueForKey:@"FileData"]]];
                    
                    
                    if (self->_pdfImageArray != (id)[NSNull null])
                    {
                        int Count;
                        NSData *data = [[NSData alloc]initWithBase64EncodedString:self->_pdfImageArray options:0];
                        NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                        NSString *path = [documentsDirectory stringByAppendingPathComponent:self->_documentName];
                        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
                        for (Count = 0; Count < (int)[directoryContent count]; Count++)
                        {
                            NSLog(@"File %d: %@", (Count + 1), [directoryContent objectAtIndex:Count]);
                        }
                        [self->_addFile addObject:path];
                        
                        [data writeToFile:path atomically:YES];
                        [self stopActivity];
                        QLPreviewController *previewController=[[QLPreviewController alloc]init];
                        previewController.delegate=self;
                        previewController.dataSource=self;
                        [self presentViewController:previewController animated:YES completion:nil];
                        ;
                        [previewController.navigationItem setRightBarButtonItem:nil];                            self->_attachedToolBar.hidden = YES;
                        
                    }
                    else{
                        return;
                    }
                    
                    
                });
                
            }
            else{
                
            }
            
        }];
    }];
    
    UIAlertAction* Delete = [UIAlertAction
                             actionWithTitle:@"Delete"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
        //Handle your yes please button action here
        [self startActivity:@"Processing..."];
        
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.attachedTableView];
        NSIndexPath *indexPath = [self.attachedTableView indexPathForRowAtPoint:buttonPosition];
        NSString *requestURL = [NSString stringWithFormat:@"%@MarkAsInactive?documentId=%@&status=%@",kInactive,[[self->_listArray objectAtIndex:indexPath.row] objectForKey:@"DocumentId"],@"Attachment"];
        
        [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
            
            // if(status)
            if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
                
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                    
                    
                    self->_inactiveArray =responseValue;
                    
                    if (self->_inactiveArray != (id)[NSNull null])
                    {
                        // if (self.selectedIndexPath) {
                        [self->_listArray removeObjectAtIndex:indexPath.row];
                        // }
                        self->_attachedToolBar.hidden = YES;
                        [self->_attachedTableView reloadData];
                        
                        [self stopActivity];
                    }
                    else{
                        
                        
                        UIAlertController * alert = [UIAlertController
                                                     alertControllerWithTitle:@"Info"
                                                     message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        
                        //Add Buttons
                        
                        UIAlertAction* yesButton = [UIAlertAction
                                                    actionWithTitle:@"Ok"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                            //Handle your yes please button action here
                            
                        }];
                        
                        
                        //Add your buttons to alert controller
                        
                        [alert addAction:yesButton];
                        [self presentViewController:alert animated:YES completion:nil];
                        [self stopActivity];
                    }
                    
                });
                
            }
            else{
                
                
            }
            
        }];
    }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
        
    }];
    
    [Download setValue:[[UIImage imageNamed:@"download.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [Delete setValue:[[UIImage imageNamed:@"trash-can-outline.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    [Download setValue:kCAAlignmentLeft forKey:@"titleTextAlignment"];
    [Delete setValue:kCAAlignmentLeft forKey:@"titleTextAlignment"];
    
    view.view.tintColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    
    if ([[[_listArray objectAtIndex:indexPath.row] objectForKey:@"IsDelete"] boolValue] == 1) {
        [view addAction:Delete];
        [view addAction:Download];
    }
    else [view addAction:Download];
    // [view addAction:Share];
    
    [view addAction:cancel];
    
    [self presentViewController:view animated:YES completion:nil];
    
}


- (IBAction)downloadBtn:(id)sender {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Download File"
                                 message:@"Do you want to download document?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
        //Handle your yes please button action here
        [self startActivity:@"Loading..."];
        
        NSString *requestURL = [NSString stringWithFormat:@"%@GetDraftFileData?workFlowId=%@",kDownloadPdf,self->_documentID];
        [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
            
            //  if(status)
            if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
                
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self->_addFile removeAllObjects];
                    
                    self->_pdfImageArray=[[AppDelegate AppDelegateInstance] strCheckNull:[NSString stringWithFormat:@"%@",[[responseValue valueForKey:@"Response"] valueForKey:@"FileData"]]];
                    if (self->_pdfImageArray != (id)[NSNull null])
                    {
                        int Count;
                        NSData *data = [[NSData alloc]initWithBase64EncodedString:self->_pdfImageArray options:0];
                        NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                        NSString *path = [documentsDirectory stringByAppendingPathComponent:self->_documentName];
                        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
                        for (Count = 0; Count < (int)[directoryContent count]; Count++)
                        {
                            NSLog(@"File %d: %@", (Count + 1), [directoryContent objectAtIndex:Count]);
                        }
                        [self->_addFile addObject:path];
                        
                        [data writeToFile:path atomically:YES];
                        [self stopActivity];
                        QLPreviewController *previewController=[[QLPreviewController alloc]init];
                        previewController.delegate=self;
                        previewController.dataSource=self;
                        [self presentViewController:previewController animated:YES completion:nil];
                        ;
                        [previewController.navigationItem setRightBarButtonItem:nil];                            self->_attachedToolBar.hidden = YES;
                        
                    }
                    else{
                        return;
                    }
                    
                    
                });
                
            }
            else{
                
            }
            
        }];
        
    }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
        //Handle your yes please button action here
        
    }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)cancelBtn:(id)sender {
    _attachedToolBar.hidden = YES;
}

- (IBAction)uploadAttachments:(id)sender {
    
    //EMIOS1108
    if ((_descText.text.length == (id)[NSNull null]) || ([_descText.text isEqualToString:@""])) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter the description" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:true completion:nil];
    } else {
        
    /*    //Test
        if([_isFromWF isEqualToString:@"Y"]) {
            
            [self initiateWorkFlow];
        }else{
            
            [[NSUserDefaults standardUserDefaults] setValue:self.descText.text forKey:@"desc"];
            
            [self callForUploadAttachments:_documentID :_documentName :self.descText.text :_base64Image];
        }
        //Test
     */
        
       NSLog(@"Click on Add Attachment");
        
        _isAttached = true;
        
        [[NSUserDefaults standardUserDefaults] setValue:self.descText.text forKey:@"desc"];
        
        UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UploadDocuments *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"UploadDocuments"];
        objTrackOrderVC.uploadAttachment = true;
        objTrackOrderVC.isDocStore = true;
        objTrackOrderVC.documentId = _documentID;
        objTrackOrderVC.post = _parametersForWorkflow;
        objTrackOrderVC.modalPresentationStyle = UIModalPresentationFullScreen;
        UINavigationController *objNavigationController = [[UINavigationController alloc]initWithRootViewController:objTrackOrderVC];
        if (@available(iOS 13.0, *)) {
                   [objNavigationController setModalPresentationStyle: UIModalPresentationFullScreen];
        }
        [self presentViewController:objNavigationController animated:true completion:nil]; 
        
        
        
        /*  [[NSUserDefaults standardUserDefaults] setValue:self.descText.text forKey:@"desc"];
         
         [self callForUploadAttachments:_documentID :_documentName :self.descText.text :_base64Image]; */
        
        /*  if(_isAttached == true){
         NSLog(@"Attached Dcouemtn - True");
         }else{
         NSLog(@"Attached Dcouemtn - False");
         }
         
         if (attachedDict.count > 0){
         NSLog(@"Attach Dict is not empty");
         }else{
         NSLog(@"Attach - Attachment Data First");
         } */
        
        /*  NSDictionary * attachmentDict = [dict valueForKey:@"attachemtDict"];
         NSString * base64FileData = [attachmentDict valueForKey:@"Base64FileData"];
         NSString * documentName = [attachmentDict valueForKey:@"DocumentName"];*/
        
        //  [self callForUploadAttachments:_documentID :_documentName :self.descText.text :_base64Image];
        
        
        /*if (_isAttached == false) {
         UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         UploadDocuments *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"UploadDocuments"];
         objTrackOrderVC.uploadAttachment = true;
         objTrackOrderVC.isDocStore = true;
         objTrackOrderVC.documentId = _documentID;
         objTrackOrderVC.post = _parametersForWorkflow;
         objTrackOrderVC.modalPresentationStyle = UIModalPresentationFullScreen;
         UINavigationController *objNavigationController = [[UINavigationController alloc]initWithRootViewController:objTrackOrderVC];
         [self presentViewController:objNavigationController animated:true completion:nil];
         
         } else {
         
         [self callForUploadAttachments:_documentID :_documentName :self.descText.text :_base64Image];
         
         } */
        
    }
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:picker completion:nil];
    UIImage* imag = [info valueForKey:UIImagePickerControllerOriginalImage];
    //UIImageView *  imageView ;
    // imageView.image = imag;
    NSData *imageData = UIImagePNGRepresentation(imag);
    base64String = [imageData base64EncodedStringWithOptions:0];
    
    refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    // NSString *filename = [refURL.lastPathComponent];
    
    self.uploadAttachment.hidden = false;
    
    //call api
    //  [self callForUploadAttachments:_documentID :refURL.lastPathComponent :self.descText.text :base64String];
    
}

#pragma mark- Open Document Picker(Delegate) for PDF, DOC Slection from iCloud


- (void)showDocumentPickerInMode:(UIDocumentPickerMode)mode
{
    
    UIDocumentMenuViewController *picker =  [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"com.adobe.pdf"] inMode:UIDocumentPickerModeImport];
    
    picker.delegate = self;
    //picker.allowsMultipleSelection = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
    //    [self presentViewController:picker animated:YES completion:^{
    //        if (@available(iOS 11.0, *)) {
    //            picker.allowsMultipleSelection = YES;
    //        }
    //    }];
    
}


-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker
{
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller
  didPickDocumentAtURL:(NSURL *)url
{
    PDFUrl= url;
    UploadType=@"PDF";
    [arrImg removeAllObjects];
    [arrImg addObject:url];
    
    NSLog(@"%@",url.lastPathComponent);
    
    NSData *data2 = [NSData dataWithContentsOfURL:url];
    NSString *path = [url path];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    NSData *dataPdf = [[NSData alloc]initWithBase64EncodedString:base64Encoded options:0];
    
    pdfDocument = [[PDFDocument alloc] initWithData:dataPdf];
    NSLog(@"%lu%@",(unsigned long)pdfDocument.pageCount,pdfDocument.documentAttributes);
    
    //  [self callForUploadAttachments:_documentID :url.lastPathComponent :self.descText.text :base64Encoded];
    
}

//MARK: Add/Upload Attachment API Call

-(void)callForUploadAttachments:(NSString *)DocumentID :(NSString*)AttachmentName :(NSString*)Description :(NSString*)Base64FileData{
    //Adarsha
    // int documentid = [DocumentID intValue];// [NSInteger numberWithInteger:[DocumentID integerValue]] ;
    //  //  Base64FileData = [[Base64FileData stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
    //      //                stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSMutableDictionary * post = [[NSMutableDictionary alloc]init];
    [post setObject:DocumentID forKey:@"ParentDocumentID"];
    [post setObject:AttachmentName forKey:@"AttachmentName"];
    [post setObject:Description forKey:@"Description"];
    [post setObject:Base64FileData forKey:@"Base64FileData"];
    
    NSMutableArray * postArray = [[NSMutableArray alloc]init];
    [postArray addObject:post];
    
    
    //  NSString *post = [NSString stringWithFormat:@"DocumentID=%@&AttachmentName=%@&Description=%@&Base64FileData=%@",DocumentID,AttachmentName,Description,Base64FileData];
    //post = [[post stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
    //stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [self startActivity:@"Refreshing"];
    
    [WebserviceManager sendSyncRequestWithURLDocument:kSaveAttachments method:SAServiceReqestHTTPMethodPOST body:post completionBlock:^(BOOL status, id responseValue){
        
        if (status) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Password"];
            
            //[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:checkPassword];
            NSNumber * isSuccessNumber = (NSNumber *)[responseValue valueForKey:@"IsSuccess"];
            if([isSuccessNumber boolValue] == YES)
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                    
                    
                    //if ([_document isEqualToString:@"ListAttachments"]) {
                    //  _workFlowId = (NSString *)[responseValue valueForKey:@"Response"];
                    [self ListAttachments];
                    [self stopActivity];
                    //EMIOS1108
                    self.descText.text = @"";
                    
                    //clear the test
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"desc"];
                    // }
                    // else
                    //  {
                    //   [self getAttachments];
                    // }
                    
                    NSArray * msgArr = [responseValue valueForKey:@"Messages"];
                    NSString *msg = @"";
                    
                    if (msgArr == (id)[NSNull null]){
                        msg = @"No Message Found";
                    }else{
                        if (msgArr.count > 0){
                            msg = [msgArr objectAtIndex:0];
                        }else{
                            msg = @"Uploaded Successfully";
                        }
                    }
                    
                    
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@""
                                                 message:msg
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    //Add Buttons
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                        //Handle your yes please button action here
                        // [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    //Add your buttons to alert controller
                    
                    [alert addAction:yesButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    return;
                    
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                    [self stopActivity];
                });
            }
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                [self stopActivity];
            });
        }
        
    }];
}

#pragma mark - call for init workflow and dismiss view controller

- (IBAction)dismissVC:(id)sender {
    // [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)sendInitWorkflow:(id)sender {
    
    [self startActivity:@""];
    [WebserviceManager sendSyncRequestWithURLDocument:kInitiateWorkflow method:SAServiceReqestHTTPMethodPOST body:_parametersForWorkflow completionBlock:^(BOOL status, id responseValue){
        
        if (status) {
            int   issucess = [[responseValue valueForKey:@"IsSuccess"]intValue];
            
            if (issucess != 0) {
                
                NSNumber * isSuccessNumber = (NSNumber *)[responseValue valueForKey:@"IsSuccess"];
                if([isSuccessNumber boolValue] == YES)
                {
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                        
                        [self stopActivity];
                        
                        
                        UIAlertView * alert15 =[[UIAlertView alloc ] initWithTitle:@"" message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert15 show];
                        
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        LMNavigationController *objTrackOrderVC= [sb  instantiateViewControllerWithIdentifier:@"HomeNavController"];
                        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:objTrackOrderVC];
                        
                    });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                        UIAlertController * alert = [UIAlertController
                                                     alertControllerWithTitle:@""
                                                     message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        
                        //Add Buttons
                        
                        UIAlertAction* yesButton = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                            //Handle your yes please button action here
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        //Add your buttons to alert controller
                        
                        [alert addAction:yesButton];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                        [self stopActivity];
                    });
                    
                }
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self stopActivity];
                    
                    UIAlertView * alert15 =[[UIAlertView alloc ] initWithTitle:@"" message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert15 show];
                });
                
            }
            
        }
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
            [self stopActivity];
            
            UIAlertView * alert15 =[[UIAlertView alloc ] initWithTitle:@"" message:@"Failed to intitiating the workFlow." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert15 show];
        }
    }];
    
}


#pragma mark - data source(Preview)

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return [_addFile count];
    
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSString *fileName = [_addFile objectAtIndex:index];
    return [NSURL fileURLWithPath:fileName];
}

#pragma mark - delegate methods


- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item
{
    return YES;
}

- (CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id <QLPreviewItem>)item inSourceView:(UIView **)view
{
    
    //Rectangle of the button which has been pressed by the user
    //Zoom in and out effect appears to happen from the button which is pressed.
    UIView *view1 = [self.view viewWithTag:currentPreviewIndex+1];
    return view1.frame;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
