//
//  ListViewController.m
//  SampleTask
//
//  Created by Prasad on 13/01/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

#import "ListViewController.h"
#import <sqlite3.h>
#import "MeetingsTableViewController.h"
@interface ListViewController (){
     sqlite3 *database;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedCtrl;
- (IBAction)segmentedCtrlChanged:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITableView *listingTableView;


@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.hidesBackButton = YES;

     UIBarButtonItem *logOutButton =  [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
     UIBarButtonItem *meetingsButton =  [[UIBarButtonItem alloc] initWithTitle:@"Meetings" style:UIBarButtonItemStylePlain target:self action:@selector(meetingsListing)];
     self.navigationItem.leftBarButtonItem = meetingsButton;
     self.navigationItem.rightBarButtonItem = logOutButton;
     self.title = @"Group Members";
     [self fetchGroupMembers];
     [[self listingTableView] reloadData];
    // Do any additional setup after loading the view.
}
-(void)logOut{
     [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)meetingsListing{
     UIStoryboard *defaultStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     MeetingsTableViewController *meetingTableViewController = [defaultStoryBoard instantiateViewControllerWithIdentifier:@"MeetingsTableViewController"];
     if (meetingTableViewController != nil) {
          [self.navigationController pushViewController:meetingTableViewController animated:YES];
     }
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

- (IBAction)segmentedCtrlChanged:(UISegmentedControl *)sender {
     [self.listingTableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     // Return the number of sections.
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     // Return the number of rows in the section.
     switch (self.segmentedCtrl.selectedSegmentIndex) {
          case 0:
          {
               return self.group1Members.count;
          }
               break;
          case 1:
          {
               return self.group2Members.count;
          }
               break;
               
          default:
          {
               return 0;
          }
               break;
     }
     
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupListing" forIndexPath:indexPath];
      MemberObject *memberObject;
 // Configure the cell...
      switch (self.segmentedCtrl.selectedSegmentIndex) {
           case 0:
           {
                memberObject = self.group1Members[indexPath.row];
                cell.detailTextLabel.text = @"Group 1";
           }
                break;
           case 1:
           {
                memberObject = self.group2Members[indexPath.row];
                cell.detailTextLabel.text = @"Group 2";
           }
                break;
                
           default:
           {
           }
                break;
      }
 cell.textLabel.text = memberObject.memberName;
 return cell;
 }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     MemberObject *memberObject;
     switch (self.segmentedCtrl.selectedSegmentIndex) {
          case 0:
          {
               memberObject = self.group1Members[indexPath.row];
          }
               break;
          case 1:
          {
               memberObject = self.group2Members[indexPath.row];
          }
               break;
               
          default:
          {
               
          }
               break;
     }
     UIStoryboard *defaultStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

     GroupMemberTableViewController *groupMemberTableViewController = [defaultStoryBoard instantiateViewControllerWithIdentifier:@"GroupMemberTableViewController"];
     groupMemberTableViewController.userObject = self.userObject;
     groupMemberTableViewController.selectedMember = memberObject;
     if (groupMemberTableViewController != nil) {
          UINavigationController *naviObj = [[UINavigationController alloc] initWithRootViewController:groupMemberTableViewController];
          [self presentViewController:naviObj animated:YES completion:nil];
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


-(void)fetchGroupMembers{
     
     static sqlite3_stmt *statement = nil;
     NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDir = [documentPaths objectAtIndex:0];
     NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"Sample.sqlite"];
     if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
     {
          NSString *selectSQL = @"Select MemberName, MemberID, GroupID from GroupTbl Order By MemberName";
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
                         switch ([memberObject.memberGroupID integerValue]) {
                              case 1:
                              {
                                   if (self.group1Members == nil) {
                                        _group1Members = [[NSMutableArray alloc] init];
                                        
                                   }
                                   [self.group1Members addObject:memberObject];
                              }
                                   break;
                              case 2:
                              {
                                   if (self.group2Members == nil) {
                                        _group2Members = [[NSMutableArray alloc] init];
                                        
                                   }
                                   [self.group2Members addObject:memberObject];
                              }
                                   break;
                              default:
                                   break;
                         }
                    }
               }
          }
          sqlite3_finalize(statement);
          sqlite3_close(database);
     }
     
     
}

@end
