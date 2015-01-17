//
//  ClassObjects.h
//  SampleTask
//
//  Created by Prasad on 13/01/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject
@property (strong,nonatomic) NSString* userName;
@property (strong,nonatomic) NSString* userID;
@end

@interface MemberObject : NSObject
@property(strong,nonatomic) NSString* memberName;
@property(strong,nonatomic) NSString* memberID;
@property(strong,nonatomic) NSString* memberGroupID;
@end

@interface MeetingObject : NSObject
-(id)initWithMeetingDate:(NSString *)meetDate withMemberID1:(NSInteger)memberID1 withMemberID2:(NSInteger)memberID2 withUserID:(NSInteger)userID withMeetingID:(NSString *)meetingID;
@property(strong,nonatomic)NSString *meetingId;
@property(strong,nonatomic) MemberObject* member1;
@property(strong,nonatomic) MemberObject* member2;
@property(strong,nonatomic) NSString* meetingDate;
@property(strong,nonatomic) UserObject *userObject;
@end