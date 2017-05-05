//
//  User.h
//  FirstTask
//
//  Created by user on 18.04.17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGNUser: NSObject<NSCopying>
@property (atomic, retain) NSNumber *userId; //unique user id, rewrite get/set methods
@property (nonatomic, retain) NSMutableString *firstName; //rewrite get/set methods
@property (nonatomic, copy) NSMutableString *lastName; //rewrite get/set methods
@property (nonatomic, retain) NSDate *birthDate;
@property (atomic, copy, readonly) NSArray *followers; //contains instances of Friends, rewrite get/set methods
@property (nonatomic, retain, readonly) NSArray *following; //contains instances of Friends
@property (nonatomic, retain) NSDictionary *address; //map, containing info about city, country, postcode
@property (nonatomic, copy, readonly) NSString *city; //On base of info in address dict.
@property (nonatomic, copy, readonly) NSString *country; //On base of info in address dict.
@property (nonatomic, assign, readonly, getter=isContactUser) BOOL contactUser; //make readonly, make get-method isContactuser
                                                                               //rewrite get/set methods (set method is not required because of readonly attribute)
//additional properties for tests
//@property(nonatomic, retain) NSObject *testRetainProp;
//@property(nonatomic, copy) NSObject *testCopyProp;

+ (instancetype)userWithId:(NSNumber *)userId
                    firstName:(NSString *)firstName
                    lastName:(NSString *)lastName;
- (instancetype)initUserWithId:(NSNumber *)userId
                    firstName:(NSString *)firstName
                    lastName:(NSString *)lastName;
- (instancetype)initWithUserId:(NSNumber *)userId;
- (instancetype)initWithLastName:(NSString *)lastName;
- (instancetype)initWithFirstName:(NSString *)firstName;

//- (instancetype)copyWithZone:(NSZone *)zone; //No need to declare: alredy exists
//-(NSString *)description; //no need in additional declaring of parent methods
//-(void)dealloc; //no need in additional declaring of parent methods
@end

@interface NGNUser (NGNCommonUserMaintenance)
-(void)printFullName; // writes full name in console
@end

#pragma mark - Follwers/following maintenance
@interface NGNUser (NGNUserFollowersMaintanance)
- (void)addFollower:(NGNUser *)follower; // adding friend into followers array
- (void)removeFollower:(NGNUser *)follower; // remove friend from followers array
- (BOOL)isFollowerPerson:(NGNUser *)person; // returns bool value
- (void)addFollowing:(NGNUser *)following; // adding friend into following
- (void)removeFollowing:(NGNUser *)following; // removing friend from following
- (BOOL)isFollowingPerson:(NGNUser *)person;  // returns bool value
@end

//#pragma mark - rewritten accsessors/mutators
////No need to reorder get/set methods: they were already created by the properties

//@interface NGNUser (NGNUserRewriteAcsessorsMutators)
//-(NSNumber *)userId; //getUserId
//-(void)setUserId:(NSNumber *)userId; //setUserId
//-(NSMutableString *)firstName; //getFirstName
//-(void)setFirstName:(NSMutableString *)firstName; //setFirstName
//-(NSMutableString *)lastName; //getLastName
//-(void)setLastName:(NSMutableString *)lastName; //setlastName
//-(NSMutableArray *)followers; //getFollowers
////-(void)setFollowers:(NSArray *)followers; //setFollowers here we make immutable array
////-(void)setFollowing:(NSArray *)following; //setFollowing here we make immutable array
//-(BOOL)isContactUser; //rewritten getter for contactUser field
//@end
