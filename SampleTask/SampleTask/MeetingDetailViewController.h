//
//  MeetingDetailViewController.h
//  SampleTask
//
//  Created by Prasad on 13/01/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassObjects.h"
#import <sqlite3.h>
@interface MeetingDetailViewController : UIViewController
@property(strong,nonatomic)MeetingObject *meetingObject;
@property(strong,nonatomic)MemberObject *selectedMember1;
@property(strong,nonatomic)MemberObject *selectedMember2;
@property(strong,nonatomic)UserObject *userObject;
@property(strong,nonatomic)UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *groupTitleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *groupTitleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel1;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel2;
@property (weak, nonatomic) IBOutlet UITextField *meetingDateTextField;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong,nonatomic)NSDate *selectedDate;
- (IBAction)saveButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;


@end
