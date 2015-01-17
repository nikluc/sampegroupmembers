//
//  ListViewController.h
//  SampleTask
//
//  Created by Prasad on 13/01/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassObjects.h"
#import "GroupMemberTableViewController.h"
@interface ListViewController : UIViewController
@property(strong,nonatomic)NSMutableArray *group1Members;
@property(strong,nonatomic)NSMutableArray *group2Members;
@property(strong,nonatomic)UserObject *userObject;
@end
