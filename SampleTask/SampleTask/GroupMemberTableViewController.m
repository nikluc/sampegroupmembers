//
//  GroupMemberTableViewController.m
//  SampleTask
//
//  Created by Prasad on 13/01/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

#import "GroupMemberTableViewController.h"
#import <sqlite3.h>

@interface GroupMemberTableViewController ()
{
     sqlite3 *database;
}
@end

@implementation GroupMemberTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView)];
     self.navigationItem.rightBarButtonItem = doneButton;
     
     
     switch (([self.selectedMember.memberGroupID integerValue])) {
          case 1:
          {
               [self fetchGroupMembers:2];
               self.title = @"Group 2";
               
          }
               break;
          case 2:
          {
               [self fetchGroupMembers:1];
               self.title = @"Group 1";
          }
               break;
               
          default:
               break;
     }
     [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissView{
     [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.groupMembersArray count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     switch (([self.selectedMember.memberGroupID integerValue])) {
          case 1:
          {
               return  @"Select Group 2 Member";
               
          }
               break;
          case 2:
          {

               return  @"Select Group 1 Member";
          }
               break;
               
          default:
               return @"";
               break;
     }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupMembers" forIndexPath:indexPath];
     MemberObject *memberObject = self.groupMembersArray[indexPath.row];
     cell.textLabel.text = memberObject.memberName;
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath     {
      MemberObject *memberObject = self.groupMembersArray[indexPath.row];
     UIStoryboard *defaultStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     MeetingDetailViewController *meetingDetailViewController = [defaultStoryBoard instantiateViewControllerWithIdentifier:@"MeetingDetailViewController"];
     meetingDetailViewController.meetingObject = nil;
     meetingDetailViewController.userObject = self.userObject;
     meetingDetailViewController.selectedMember1 = self.selectedMember;
     meetingDetailViewController.selectedMember2 = memberObject;
     if (meetingDetailViewController != nil) {
          [self.navigationController pushViewController:meetingDetailViewController animated:YES];
     }
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
-(void)fetchGroupMembers:(NSInteger)groupID{
     [self.groupMembersArray removeAllObjects];
     static sqlite3_stmt *statement = nil;
     NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDir = [documentPaths objectAtIndex:0];
     NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"Sample.sqlite"];
     if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
     {
          NSString *selectSQL = [NSString stringWithFormat:@"Select MemberName, MemberID, GroupID from GroupTbl where GroupID='%ld' Order By MemberName",(long)groupID];
          NSLog(@"%@",selectSQL);
          const char *select_stmt = [selectSQL UTF8String];
          if(sqlite3_prepare_v2(database, select_stmt, -1, &statement, nil)== SQLITE_OK)
          {
               while(sqlite3_step(statement) == SQLITE_ROW)
               {
                    if (sqlite3_column_text(statement, 0)==NULL) {
                    }
                    else{
                         MemberObject *memberObject = [[MemberObject alloc] init];
                         memberObject.memberName = [[NSString alloc] initWithUTF8String:
                                                    (const char *) sqlite3_column_text(statement, 0)];
                         memberObject.memberID = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement,1)];
                         memberObject.memberGroupID = [[NSString alloc] initWithUTF8String:
                                                       (const char *) sqlite3_column_text(statement, 2)];
                         if (self.groupMembersArray==nil) {
                              _groupMembersArray = [[NSMutableArray alloc] init];
                         }
                         [self.groupMembersArray addObject:memberObject];
                    }
               }
          }
          sqlite3_finalize(statement);
          sqlite3_close(database);
     }
     
     
}


@end
