//
//  MeetingsTableViewController.m
//  SampleTask
//
//  Created by Prasad on 13/01/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

#import "MeetingsTableViewController.h"
#import "MeetingCell.h"
#import "ClassObjects.h"
#import "MeetingDetailViewController.h"
@interface MeetingsTableViewController ()

@end

@implementation MeetingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self fetchMeetings];
     self.title = @"Meetings";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.meetingsArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     if (self.meetingsArray.count == 0) {
          return @"No Meetings Scheduled";
     }
     return @"Scheduled Meetings";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meetings" forIndexPath:indexPath];
     MeetingObject *meetingObj = self.meetingsArray[indexPath.row];
     cell.member1.text = meetingObj.member1.memberName;
     cell.member2.text = meetingObj.member2.memberName;
     NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
     dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
     
     NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
     dateFormatter1.dateFormat = @"MM-dd-yyyy 'at' HH:mm";
     
     NSDate *meetingDate = [dateformatter dateFromString:meetingObj.meetingDate];
     
     cell.meetingDate.text = [dateFormatter1 stringFromDate:meetingDate];
     
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     MeetingObject *meetingObj = self.meetingsArray[indexPath.row];
     UIStoryboard *defaultStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     MeetingDetailViewController *meetingDetailViewController = [defaultStoryBoard instantiateViewControllerWithIdentifier:@"MeetingDetailViewController"];
     meetingDetailViewController.meetingObject = meetingObj;
     if (meetingDetailViewController != nil) {
          [self.navigationController pushViewController:meetingDetailViewController animated:YES];
     }
     
     
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     
}
-(void)fetchMeetings{
     [self.meetingsArray removeAllObjects];
     static sqlite3_stmt *statement = nil;
     NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDir = [documentPaths objectAtIndex:0];
     NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"Sample.sqlite"];
     if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
     {
          NSString *selectSQL = @"Select MeetingID, MemberID1, MemberID2, MeetingPeriod,CreatedBy from MeetingTbl where MeetingPeriod > datetime('now','localtime') Order By MeetingPeriod";
          NSLog(@"%@",selectSQL);
          const char *select_stmt = [selectSQL UTF8String];
          if(sqlite3_prepare_v2(database, select_stmt, -1, &statement, nil)== SQLITE_OK)
          {
               while(sqlite3_step(statement) == SQLITE_ROW)
               {
                    if (sqlite3_column_text(statement, 0)==NULL) {
                    }
                    else{

                         NSString *meetingID = [[NSString alloc] initWithUTF8String:
                                                    (const char *) sqlite3_column_text(statement, 0)];
                         NSString *memberID1 = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement,1)];
                         NSString *memberID2 = [[NSString alloc] initWithUTF8String:
                                                       (const char *) sqlite3_column_text(statement, 2)];
                         NSString *meetDate = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 3)];
                         NSString *userID = [[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 4)];
                         
                         MeetingObject *meetingObject = [[MeetingObject alloc] initWithMeetingDate:meetDate withMemberID1:[memberID1 integerValue] withMemberID2:[memberID2 integerValue] withUserID:[userID integerValue] withMeetingID:meetingID];
                         if (self.meetingsArray == nil) {
                              _meetingsArray = [[NSMutableArray alloc] init];
                              
                         }
                         [self.meetingsArray addObject:meetingObject];

                    }
               }
          }
          sqlite3_finalize(statement);
          sqlite3_close(database);
     }
     
     
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
