//
//  ViewController.m
//  SampleTask
//
//  Created by Prasad on 13/01/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

#import "ViewController.h"
#import "ListViewController.h"
#import <sqlite3.h>
@interface ViewController (){
     sqlite3 *database;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginButtonTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
     [super viewDidLoad];
     // Do any additional setup after loading the view, typically from a nib.
     UIToolbar *keyboardAccessory = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
     UIBarButtonItem *flexibleWidth = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
     UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
     keyboardAccessory.items = @[flexibleWidth,doneButton];
     self.userNameTextField.inputAccessoryView = keyboardAccessory;
     self.passwordTextField.inputAccessoryView = keyboardAccessory;
}

- (void)didReceiveMemoryWarning {
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}
-(void)doneButtonPressed{
     [self.view endEditing:YES];
}
- (IBAction)loginButtonTapped:(id)sender {
     if ([self.userNameTextField hasText]) {
          if ([self.passwordTextField hasText]) {
               if ([self signIn]) {
                    UIStoryboard *defaultStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ListViewController *listViewController = [defaultStoryBoard instantiateViewControllerWithIdentifier:@"ListViewController"];
                    listViewController.userObject = self.userObject;
                    if (listViewController != nil) {
                         [self.navigationController pushViewController:listViewController animated:YES];
                    }
               }

               else{
                    [self showAlert:@"Invalid UserName / Password" WithTitle:@"Login"];
               }
          }
          else{
               [self showAlert:@"Enter Password" WithTitle:@"Validation"];
          }
     }
     else{
          [self showAlert:@"Enter Username" WithTitle:@"Validation"];
     }
}
-(void)showAlert:(NSString *)message WithTitle:(NSString *)title{
     [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}
-(BOOL)signIn{
     
     BOOL loginStatus = false;
     static sqlite3_stmt *statement = nil;
     NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDir = [documentPaths objectAtIndex:0];
     NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"Sample.sqlite"];
          if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
     {
          NSString *selectSQL = [NSString stringWithFormat: @"Select UserID, Password, UserName from UserTbl where UserName = '%@'",self.userNameTextField.text];
          NSLog(@"%@",selectSQL);
          const char *select_stmt = [selectSQL UTF8String];
          if(sqlite3_prepare_v2(database, select_stmt, -1, &statement, nil)== SQLITE_OK)
          {
               while(sqlite3_step(statement) == SQLITE_ROW)
               {
                    if (sqlite3_column_text(statement, 0)==NULL) {
                         loginStatus = false;
                    }
                    else{
                         self.userObject = nil;
                         _userObject = [[UserObject alloc] init];
                         self.userObject.userID = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 0)];
                         NSString *pwd = [[NSString alloc] initWithUTF8String:
                                                    (const char *) sqlite3_column_text(statement, 1)];
                         self.userObject.userName = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 2)];
                         if ([pwd isEqualToString:self.passwordTextField.text]) {
                              loginStatus = true;
                         }
                    }
               }
          }
          sqlite3_finalize(statement);
          sqlite3_close(database);
     }

     return loginStatus;
     
}
@end
