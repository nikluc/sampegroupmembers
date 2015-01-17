//
//  ClassObjects.m
//  SampleTask
//
//  Created by Prasad on 13/01/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

#import "ClassObjects.h"
#import <sqlite3.h>
@implementation UserObject

@end


@implementation MemberObject

@end

@implementation MeetingObject{
          sqlite3 *database;
}
-(id)initWithMeetingDate:(NSString *)meetDate withMemberID1:(NSInteger)memberID1 withMemberID2:(NSInteger)memberID2 withUserID:(NSInteger)userID withMeetingID:(NSString *)meetingID{
     self = [super init];
     if (self) {
          self.meetingId = meetingID;
          self.userObject = [self getUserObject:userID];
          self.member1 = [self getGroupMember:memberID1];
          self.member2 = [self getGroupMember:memberID2];
          self.meetingDate = meetDate;
     }
     return self;
}
-(UserObject *)getUserObject:(NSInteger)UserID{
     UserObject *userObject;
     static sqlite3_stmt *statement = nil;
     NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDir = [documentPaths objectAtIndex:0];
     NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"Sample.sqlite"];
     if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
     {
          NSString *selectSQL = [NSString stringWithFormat: @"Select UserID, UserName from UserTbl where UserID = '%d'",UserID];
          NSLog(@"%@",selectSQL);
          const char *select_stmt = [selectSQL UTF8String];
          if(sqlite3_prepare_v2(database, select_stmt, -1, &statement, nil)== SQLITE_OK)
          {
               while(sqlite3_step(statement) == SQLITE_ROW)
               {
                    if (sqlite3_column_text(statement, 0)==NULL) {
                         userObject = nil;
                    }
                    else{
                         userObject = [[UserObject alloc] init];
                         userObject.userID = [[NSString alloc] initWithUTF8String:
                                                   (const char *) sqlite3_column_text(statement, 0)];
                        userObject.userName = [[NSString alloc] initWithUTF8String:
                                                     (const char *) sqlite3_column_text(statement, 1)];

                    }
               }
          }
          sqlite3_finalize(statement);
          sqlite3_close(database);
     }
     
     return userObject;
     
}
-(MemberObject *)getGroupMember:(NSInteger)memberID{
     MemberObject *memberObject;
     static sqlite3_stmt *statement = nil;
     NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDir = [documentPaths objectAtIndex:0];
     NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"Sample.sqlite"];
     if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
     {
          NSString *selectSQL = [NSString stringWithFormat:@"Select MemberName, MemberID, GroupID from GroupTbl where MemberID = '%d'",memberID];;
          NSLog(@"%@",selectSQL);
          const char *select_stmt = [selectSQL UTF8String];
          if(sqlite3_prepare_v2(database, select_stmt, -1, &statement, nil)== SQLITE_OK)
          {
               while(sqlite3_step(statement) == SQLITE_ROW)
               {
                    if (sqlite3_column_text(statement, 0)==NULL) {
                         memberObject = nil;
                    }
                    else{
                         memberObject = [[MemberObject alloc] init];
                         memberObject.memberName = [[NSString alloc] initWithUTF8String:
                                                    (const char *) sqlite3_column_text(statement, 0)];
                         memberObject.memberID = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement,1)];
                         memberObject.memberGroupID = [[NSString alloc] initWithUTF8String:
                                                       (const char *) sqlite3_column_text(statement, 2)];
                    }
               }
          }
          sqlite3_finalize(statement);
          sqlite3_close(database);
     }
     return memberObject;
     
}

@end