//
//  GroupMemberTableViewController.h
//  SampleTask
//
//  Created by Prasad on 13/01/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassObjects.h"
#import "MeetingDetailViewController.h"
@interface GroupMemberTableViewController : UITableViewController
@property(strong,nonatomic)MemberObject *selectedMember;
@property(strong,nonatomic)UserObject *userObject;
@property(strong,nonatomic)NSMutableArray *groupMembersArray;
@end
