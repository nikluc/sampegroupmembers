//
//  MeetingsTableViewController.h
//  SampleTask
//
//  Created by Prasad on 13/01/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface MeetingsTableViewController : UITableViewController{
               sqlite3 *database;
}
@property(strong,nonatomic)NSMutableArray *meetingsArray;
@end
