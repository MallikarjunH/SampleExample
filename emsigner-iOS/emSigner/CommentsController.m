//
//  CommentsController.m
//  emSigner
//
//  Created by EMUDHRA on 14/08/19.
//  Copyright © 2019 Emudhra. All rights reserved.
//

#import "CommentsController.h"
#import "DropDownCell.h"
#import "HoursConstants.h"
#import "NSObject+Activity.h"
#import "MBProgressHUD.h"
#import "WebserviceManager.h"
#import <ActionSheetPicker.h>
#import "DocumentNameHeader.h"

@interface CommentsController ()
{
    NSMutableArray * commentsCountArray ;
    NSArray * countArr;
    NSString * commentId;
    
    NSMutableArray * documentNameListArray;
    NSMutableArray * documentIdListArray;
    NSString *selectedDocumentId;
}
@end

@implementation CommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.title = @"Comments";;
    
    [_postButton setTitle:@"Post" forState:UIControlStateNormal];
    
   // self.navigationController.navigationBar.topItem.title = @" ";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    selectedDocumentId = @"";
    commentsCountArray = [[NSMutableArray alloc]init];
    documentNameListArray = [[NSMutableArray alloc]init];
    documentIdListArray = [[NSMutableArray alloc]init];
    
    self.commentsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    //[self getCommentsByWorkflowID];
   // [self getDocumentsById];
    
     [self getDocumentsById];
}


-(void)viewWillAppear:(BOOL)animated {
    
}


//GET Documents List Details
-(void) getDocumentsById{
    _documentNamesArray = [[NSMutableArray alloc]init];
    [self startActivity:@"Refreshing"];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@DownloadWorkflowDocuments?WorkflowID=%@",kMultipleDoc,self.workflowID];
    [self startActivity:@"Refreshing"];
    [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
         
        //  if(status)
        if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
            
        {
            
            self->_documentNamesArray=[responseValue valueForKey:@"Response"];
            
            [self->documentNameListArray removeAllObjects];
            [self->documentIdListArray removeAllObjects];
            
            if(self->_documentNamesArray.count>0){
                
                for (int i=0; i< self->_documentNamesArray.count; i++) {
                    
                    NSDictionary *dict = self->_documentNamesArray[i];
                    NSString *documentName = [dict objectForKey:@"DocumentName"];
                    NSString *documentId= [dict objectForKey:@"DocumentId"];
                    NSString *IsAttachment = [NSString stringWithFormat:@"%@",[dict objectForKey:@"IsAttachment"]];
                    
                    if([IsAttachment isEqualToString:@"0"]){ //is false
                        [self->documentNameListArray addObject:documentName];
                        [self->documentIdListArray addObject:documentId];
                    }
                   
                }
                [self stopActivity];
            }
            
            [self getCommentsByWorkflowID];
            
        }
        else{
            [self stopActivity];
        }
        
    }];

}

-(void)getCommentsByWorkflowID{
    _getDcommentsArray = [[NSMutableArray alloc]init];
    [self startActivity:@"Refreshing"];
   
    NSString *requestURL = [NSString stringWithFormat:@"%@GetWorkflowComments?workflowId=%@",kMultipleDoc,self.workflowID];
    
    [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
        
        //  if(status)
        if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
            
        {
            
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                self->_getDcommentsArray=[responseValue valueForKey:@"Response"];
                               if (![[[responseValue valueForKey:@"Response"]valueForKey:@"DocumentId"] isKindOfClass:[NSNull class]]) {
                                   [self.commentsTableview reloadData];
                               } else {
                                   
                                   [self.commentsTableview reloadData];
                               }
                               [self stopActivity];
                               
                           });
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                // [self.commentsTableview reloadData];
                  [self stopActivity];
            }
                           );
              
        }
        
    }];
   // [self stopActivity];
}


//Picket View
- (IBAction)selectDocumentButtonClicked:(id)sender {
    
    // Done block:
        ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            NSLog(@"Picker: %@", picker);
            NSLog(@"Selected Index: %ld", (long)selectedIndex);
            NSLog(@"Selected Value: %@", selectedValue);
            
            self->_selectedDocumentLabel.text = selectedValue;
            self->selectedDocumentId = self->documentIdListArray[selectedIndex];
           // self->selectedDocumentId = self->documentIdListArray[selectedIndex];
        };


    // cancel block:
        ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
            NSLog(@"Block Picker Canceled");
        };
    
    // Run!
    [ActionSheetStringPicker showPickerWithTitle:@"Select Document" rows:documentNameListArray initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    
    
    
}
- (IBAction)postCommentButtonClicked:(id)sender {
    //selectedDocumentId
    NSLog(@"Selected Docment Name: %@",_selectedDocumentLabel.text);
    NSLog(@"Selected Docment Id: %@",selectedDocumentId);
    
    if([_selectedDocumentLabel.text isEqualToString:@"--Select Document--"]){
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:@"Select the document!"
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
    }else{
        
        if (self.commentTextField.text.length > 0) {
            NSString *isValid = self.commentTextField.text;
            
            BOOL valid = [self validateSpecialCharactor:isValid];
            
            if (valid) {
                
                 //[self PostCall];
                
                if ([_postButton.titleLabel.text  isEqual: @"Post"]) {
                 [self PostCall];
                 
                 }
                 else{
                 [self EditCall:commentId];
                 }
            }
            else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"Special Characters are not allowed.";//[NSString stringWithFormat:@"Page %@ of %lu", self.view.currentPage.label, (unsigned long)self.pdfDocument.pageCount];
                hud.margin = 10.f;
                hud.yOffset = 170;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:2];
                
            }
        }
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.commentTextField resignFirstResponder];
    return true;
}


- (BOOL) validateSpecialCharactor: (NSString *) text {
    
    NSString *specialCharacterString = @"!~`@#$%^&*-+();:={}[],<>?\\/\"\'";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet
                                           characterSetWithCharactersInString:specialCharacterString];
    
    if ([text.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length) {
        NSLog(@"contains special characters");
        return  false;
    }
    else{
        return true;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _getDcommentsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray* commentsArr = [[_getDcommentsArray objectAtIndex:section]valueForKey:@"Comments"];
    
    return commentsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DropDownCell *cell =[tableView dequeueReusableCellWithIdentifier:@"DropDownCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    countArr = [[_getDcommentsArray objectAtIndex:indexPath.section]valueForKey:@"Comments"];
    cell.user_name.text = [countArr[indexPath.row] valueForKey:@"UserName"];
    cell.comment_label.text = [countArr[indexPath.row] valueForKey:@"Comment"];
    cell.date_label.text = [countArr[indexPath.row] valueForKey:@"CommentTime"];
    NSLog(@"%@",[countArr[indexPath.row] valueForKey:@"Comment"]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   DocumentNameHeader *headerView = [tableView dequeueReusableCellWithIdentifier:@"DocumentNameHeader"];
  
    headerView.documentNameLabel.text = [[_getDcommentsArray objectAtIndex:section]valueForKey:@"DocumentName"];
    return headerView.contentView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

      //  self.commentLabel.text = [self.documentNamesArray[indexPath.row]valueForKey:@"DocumentName"];
      //  self.documentID = [self.documentNamesArray[indexPath.row]valueForKey:@"DocumentId"];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    //Checking for SubscriberId for edit & delete
    NSString*  SubscriberId = [[NSUserDefaults standardUserDefaults]valueForKey:@"SubscriberId"];
    BOOL isReviewer = [[[_getDcommentsArray[indexPath.section]valueForKey:@"Comments"][indexPath.row]valueForKey:@"IsReviewerComment"]boolValue];
  //  ![value boolValue]
    if ([SubscriberId isEqualToString:[[_getDcommentsArray[indexPath.section]valueForKey:@"Comments"][indexPath.row]valueForKey:@"SubscriberId"]] && !isReviewer) {
        return YES;
        
    }
    else
        return false;
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your editAction here
        
        self.commentTextField.text = [[self->_getDcommentsArray[indexPath.section]valueForKey:@"Comments"][indexPath.row]valueForKey:@"Comment"];
        self->commentId = [[self->_getDcommentsArray[indexPath.section]valueForKey:@"Comments"][indexPath.row]valueForKey:@"CommentId"];
     dispatch_async(dispatch_get_main_queue(),
        ^{
            [self.commentTextField becomeFirstResponder];
         });
        self.selectedDocumentLabel.text = [self->_getDcommentsArray[indexPath.section]valueForKey:@"DocumentName"];
        [self->_postButton setTitle:@"UPDATE" forState:UIControlStateNormal];
        
    }];
    
    editAction.backgroundColor = [UIColor darkGrayColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:@"Are you sure you want delete the comment?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
            [self DeleteCall:[[self->_getDcommentsArray[indexPath.section]valueForKey:@"Comments"][indexPath.row]valueForKey:@"CommentId"] WorkflowId:[[self->_getDcommentsArray[indexPath.section]valueForKey:@"Comments"][indexPath.row]valueForKey:@"WorkflowId"]];
                                    }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     // [self.view dis]
                                 }];
        
        [alert addAction:yesButton];
        [alert addAction:cancel];
        //[self stopActivity];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction,editAction];
}

-(void)DeleteCall:(NSString*)commentId WorkflowId:(NSString *)workflowId
{
    //DeleteComment?id=commentid
 //Adarsha H
    //EMIOS117
    NSMutableDictionary * senddict = [[NSMutableDictionary alloc]init];
          
           
           //[senddict setValue:CategoryId forKey:@"CategoryID"];
           [senddict setValue:commentId forKey:@"CommentID"];
           [senddict setValue:@"" forKey:@"WorkflowID"];
           [senddict setValue:@"" forKey:@"RefrenceNo"];
    [self startActivity:@"Refreshing"];
   NSString *requestURL = [NSString stringWithFormat:@"%@DeleteComment",kMultipleDoc];
    
    [WebserviceManager sendSyncRequestWithURLDocument:requestURL method:SAServiceReqestHTTPMethodPOST body:senddict completionBlock:^(BOOL status, id responseValue) {
        
        //  if(status)
        if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
            
        {
            
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [self stopActivity];
                               if ([[responseValue valueForKey:@"IsSuccess"]integerValue] == 1) {
                                   UIAlertController * alert = [UIAlertController
                                                                alertControllerWithTitle:nil
                                                                message:@"Comments deleted successfully."
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                   
                                   //Add Buttons
                                   
                                   UIAlertAction* yesButton = [UIAlertAction
                                                               actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   [self getCommentsByWorkflowID];
                                                                [_postButton setTitle:@"POST" forState:UIControlStateNormal];

                                                               }];
                                   
                                   
                                   [alert addAction:yesButton];
                                   
                                   [self presentViewController:alert animated:YES completion:nil];

                               }
                               
                           });
            
        }
        else{
            
        }
        
    }];
    [self stopActivity];
    

}

-(void)EditCall:(NSString *)commentID
{
    
        [self startActivity:@""];
        
        // Login
        NSString *post = [NSString stringWithFormat:@"CommentId=%@&Comment=%@",commentID,self.commentTextField.text];
        
        
        [WebserviceManager sendSyncRequestWithURL:kUpdateComment method:SAServiceReqestHTTPMethodPOST body:post completionBlock:^(BOOL status, id responseValue){
            
            if (status) {
                NSNumber * isSuccessNumber = (NSNumber *)[responseValue valueForKey:@"IsSuccess"];
                if([isSuccessNumber boolValue] == YES)
                {
                    dispatch_async(dispatch_get_main_queue(),
                    ^{
                        [[[UIAlertView alloc] initWithTitle:@"" message:@"User Comments Edited Successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                        self.commentTextField.text = @"";
                        [_postButton setTitle:@"POST" forState:UIControlStateNormal];

                        [self getCommentsByWorkflowID];
                    });
                }
            }
        }];

}

-(void)PostCall
{
    [self startActivity:@""];
    
    //selectedDocumentId
   // NSString *post = [NSString stringWithFormat:@"DocumentId=%@&Comment=%@",_documentID,self.commentTextField.text];
    NSString *post = [NSString stringWithFormat:@"DocumentId=%@&Comment=%@",selectedDocumentId,self.commentTextField.text];
    [WebserviceManager sendSyncRequestWithURL:kSaveComment method:SAServiceReqestHTTPMethodPOST body:post completionBlock:^(BOOL status, id responseValue){
        
        if (status) {
            NSNumber * isSuccessNumber = (NSNumber *)[responseValue valueForKey:@"IsSuccess"];
            if([isSuccessNumber boolValue] == YES)
            {
                dispatch_async(dispatch_get_main_queue(),
                ^{
                [[[UIAlertView alloc] initWithTitle:@"" message:@"User Comments Saved Successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                self.commentTextField.text = @"";
                    [self->_postButton setTitle:@"POST" forState:UIControlStateNormal];

                [self getCommentsByWorkflowID];
                });
            }
        }
    }];

}
         

@end
