//
//  MeetingDetailViewController.m
//  SampleTask
//
//  Created by Prasad on 13/01/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

#import "MeetingDetailViewController.h"

@interface MeetingDetailViewController (){
     sqlite3 *database;
}


@end

@implementation MeetingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"Meeting Details";
    // Do any additional setup after loading the view.
     if (self.meetingObject == nil) {
          self.groupTitleLabel1.text = [NSString stringWithFormat:@"Group %@",self.selectedMember1.memberGroupID];
          self.groupTitleLabel2.text = [NSString stringWithFormat:@"Group %@",self.selectedMember2.memberGroupID];
          self.memberLabel1.text = self.selectedMember1.memberName;
          self.memberLabel2.text = self.selectedMember2.memberName;
          self.meetingDateTextField.text = nil;
          self.userName.text = [NSString stringWithFormat:@"Scheduled by: %@",self.userObject.userName];
           self.selectedDate = [NSDate date];
          self.saveButton.hidden = false;
          self.meetingDateTextField.enabled =true;
     }
     else{
          self.groupTitleLabel1.text = [NSString stringWithFormat:@"Group %@",self.meetingObject.member1.memberGroupID];
          self.groupTitleLabel2.text = [NSString stringWithFormat:@"Group %@",self.meetingObject.member2.memberGroupID];
          self.memberLabel1.text = self.meetingObject.member1.memberName;
          self.memberLabel2.text = self.meetingObject.member2.memberName;
          self.userName.text =[NSString stringWithFormat:@"Scheduled by: %@", [self.meetingObject.userObject userName]];
          NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
          dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
          
           self.selectedDate = [dateformatter dateFromString:self.meetingObject.meetingDate];
          NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
          dateFormatter1.dateFormat = @"MM-dd-yyyy 'at' HH:mm";
          self.meetingDateTextField.text = [dateFormatter1 stringFromDate:self.selectedDate];
          self.saveButton.hidden = true;
          self.meetingDateTextField.enabled =false;
     }
     UIToolbar *keyboardAccessory = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
     UIBarButtonItem *flexibleWidth = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
     UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
     keyboardAccessory.items = @[flexibleWidth,doneButton];
     _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
     [self.datePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
     self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
     self.datePicker.minimumDate = [NSDate date];
     self.meetingDateTextField.inputAccessoryView = keyboardAccessory;
     self.meetingDateTextField.inputView = self.datePicker;
    
     

}
-(IBAction)dateValueChanged:(UIDatePicker *)sender{
     self.selectedDate = [sender date];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     dateFormatter.dateFormat = @"MM-dd-yyyy 'at' HH:mm";
     self.meetingDateTextField.text = [dateFormatter stringFromDate:self.selectedDate];

}
-(void)doneButtonPressed{
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     dateFormatter.dateFormat = @"MM-dd-yyyy 'at' HH:mm";
     self.meetingDateTextField.text = [dateFormatter stringFromDate:self.selectedDate];

        [self.meetingDateTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)scheduleNewMeeting{
     BOOL status=false;
     static sqlite3_stmt *statement = nil;
     NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDir = [documentPaths objectAtIndex:0];
     NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"Sample.sqlite"];
     NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
     dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
     if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
     {
          
          
          NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO MeetingTbl(MemberID1,MemberID2, MeetingPeriod, CreatedBy) VALUES (?,?,?,?)"];
          const char *insert_stmt = [insertSQL UTF8String];
          
          if(sqlite3_prepare_v2(database, insert_stmt, -1, &statement, nil)== SQLITE_OK)
          {
               sqlite3_bind_text(statement, 1, [self.selectedMember1.memberID UTF8String],-1,SQLITE_TRANSIENT);
               sqlite3_bind_text(statement, 2, [self.selectedMember2.memberID UTF8String],-1,SQLITE_TRANSIENT);
               sqlite3_bind_text(statement, 3, [[dateformatter stringFromDate:self.selectedDate] UTF8String],-1,SQLITE_TRANSIENT);
               sqlite3_bind_text(statement, 4, [self.userObject.userID UTF8String],-1,SQLITE_TRANSIENT);
               NSLog(@"%@",self.userObject.userID);
               
          }
          NSLog(@"%@",insertSQL);
          if(SQLITE_DONE != sqlite3_step(statement))
          {
               NSLog(@"Error while selecting. '%s'", sqlite3_errmsg(database));
               //                alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Event Insertion Failed !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
               //                [alert show];
               status = false;
          }
          else
          {
               status = true;
          }
          sqlite3_finalize(statement);
          sqlite3_close(database);
     }
     return status;
     
}
- (IBAction)saveButtonTapped:(id)sender {
     if (self.meetingObject == nil) {
          if ([self.meetingDateTextField hasText]) {
               if ([self scheduleNewMeeting]) {
                    [self dismissViewControllerAnimated:YES completion:nil];
               }

          }
          else{
               [[[UIAlertView alloc] initWithTitle:@"Meeting Schedule" message:@"Enter Meeting Date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
          }
     }

}
@end
