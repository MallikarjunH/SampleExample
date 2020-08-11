//
//  DocumentLogVC.m
//  emSigner
//
//  Created by Administrator on 8/2/16.
//  Copyright © 2016 Emudhra. All rights reserved.
//

#import "DocumentLogVC.h"
#import "MBProgressHUD.h"
#import "NSObject+Activity.h"
#import "WebserviceManager.h"
#import "HoursConstants.h"
#import "AppDelegate.h"
#import "NSString+DateAsAppleTime.h"
#import "ViewController.h"


@interface DocumentLogVC ()
{
    NSString *descriptionStr;
    NSString *dateCategoryString;
    int noOfrows;
    
    NSMutableArray * actionArray;
    NSMutableArray * dateTimeArray;
    NSMutableArray * ipAddressArray;
    NSMutableArray * userEmailArray;
    
}

@end

@implementation DocumentLogVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource  = self;
    // Do any additional setup after loading the view.
    
    noOfrows = 0;
    
     actionArray = [[NSMutableArray alloc]init];
     dateTimeArray = [[NSMutableArray alloc]init];
     ipAddressArray = [[NSMutableArray alloc]init];
     userEmailArray = [[NSMutableArray alloc]init];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @" ";
    
    //  _docArray = [NSMutableArray arrayWithObjects:@"Document Name",@"Action", @"Date and Time",@"IP Address",@"User Email", nil];
    
    
    //self.title = @"Document Details";
    self.title = @"Workflow Details";;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _documentNameLabel.text = _documentName;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DocumentLogTableViewCell" bundle:nil] forCellReuseIdentifier:@"DocumentLogTableViewCell"];
    self.tableView.allowsSelection = NO;
    
    //documentName
    [self getDocumentLogDetailsAPICall];
}

-(void)getDocumentLogDetailsAPICall {
    
    [self startActivity:@"Loading..."];
    NSString *requestURL = [NSString stringWithFormat:@"%@GetDocumentLog?workflowId=%@",kDocumentlog,_workflowID];
    
    [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
        
        //  if(status)
        if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
            
        {
            
            self->_documentNamesDic = [responseValue valueForKey:@"Response"];
            NSArray *docLogs = [self->_documentNamesDic valueForKey:@"DocumentLogs"];
            
            self->noOfrows = (int) [[docLogs firstObject] count];
            
            if(docLogs.count > 0){
                
                NSArray * docArr = [docLogs firstObject];
                
                if(docArr.count > 0){
                    
                    for(int i=0;i<docArr.count;i++){
                        
                        NSDictionary * dict = docArr[i];
                        NSString *action = [dict objectForKey:@"Action"];
                        NSString *dateTime = [dict objectForKey:@"DateTime"];
                        dateTime = [dateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        NSString *userMail = [dict objectForKey:@"UserEmail"];
                        NSString *ipAddress = [dict objectForKey:@"IPAddress"];
                        
                        [self->actionArray addObject:action];
                        [self->dateTimeArray addObject:dateTime];
                        [self->ipAddressArray addObject:ipAddress];
                        [self->userEmailArray addObject:userMail];
                        
                    }
                    
                }
            }
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self->_tableView reloadData];
                [self stopActivity];
                
            });
            
        }
        else{
            
            [self stopActivity];
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:nil
                                         message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            //Add Buttons
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                //Handle your yes please button action here
                //Logout
                AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                theDelegate.isLoggedIn = NO;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:theDelegate.isLoggedIn] forKey:@"isLogin"];
                [NSUserDefaults resetStandardUserDefaults];
                [NSUserDefaults standardUserDefaults];
                UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ViewController *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"ViewController"];
                [self presentViewController:objTrackOrderVC animated:YES completion:nil];
            }];
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        }
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return noOfrows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentLogTableViewCell"];
    cell.dateTimeLable.text = [NSString stringWithFormat:@" %@",dateTimeArray[indexPath.row]];
    cell.userLabel.text = [NSString stringWithFormat:@"User: %@",userEmailArray[indexPath.row]];
    cell.actionLabel.text = [NSString stringWithFormat:@"Action: %@",actionArray[indexPath.row]];
    cell.ipAddressLabel.text = [NSString stringWithFormat:@"IP Address: %@",ipAddressArray[indexPath.row]];
    
    return  cell;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}



- (IBAction)backBtn:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}


@end
