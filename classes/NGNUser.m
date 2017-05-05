//
//  User.m
//  FirstTask
//
//  Created by user on 18.04.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "NGNUser.h"
#import "NGNUser+NGNAddress.h"


@implementation NGNUser {
    NSMutableArray *_followers; //here we make variable mutable
    NSMutableArray *_following; //here we make variable mutable
}
@synthesize userId = _userId;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize contactUser = _contactUser;
@synthesize followers = _followers; //here we synthesize getter/setter for mutable variable but(sic!) if it is copy directive in
@synthesize following = _following; //property, there will be usual copying in setter if it not rewritten
@synthesize city = _city;
@synthesize country = _country;

+(instancetype)userWithId:(NSNumber *)userId
                    firstName:(NSString *)firstName
                    lastName:(NSString *)lastName{
    return [[[self alloc] initUserWithId:userId firstName:firstName lastName:lastName]autorelease];
};

-(instancetype)initUserWithId:(NSNumber *)userId
                    firstName:(NSString *)firstName
                    lastName:(NSString *)lastName{
    if (self = [super init]) {
//        !!!!!_______ THAT'S WRONG PRACTICE TO USE ACCESSORS/MUTATORS IN INIT AND DEALLOC ________!!!!!
//        QUESTION IS: BETTER DO COPIES OF OBJECTS IN CONSTRUCTOR OR RETAIN THEIR COUNTERS?
        
        _userId = [userId copy]; //NSNumber is immutable, copy is not neccessary
        _firstName = [firstName mutableCopy];
        _lastName = [lastName mutableCopy];
        _followers = [[NSMutableArray alloc]init];
        _following = [[NSMutableArray alloc]init];
    }
    return self;
}

-(instancetype)initWithUserId:(NSNumber *) userId{
    return [self initUserWithId:userId
                      firstName:@"John"
                       lastName:@"Doe"];
}

-(instancetype)initWithLastName:(NSString *) lastName{
    return [self initUserWithId:@-1
                      firstName:@"John"
                       lastName:lastName];
}

-(instancetype)initWithFirstName:(NSMutableString *) firstName{
    return [self initUserWithId:@-1
                      firstName:firstName
                       lastName:@"Doe"];
}

// copying is not allowed, but we could return reference to current object, and we'll do so)
-(instancetype)copyWithZone:(NSZone *)zone {
    return [self retain];
}

-(void)dealloc{
//    NSLog(@"userId refCount before dealloc = %ld", CFGetRetainCount((__bridge CFTypeRef) self.userId));
    [_userId release];
//    NSLog(@"firstName refCount before dealloc = %ld", CFGetRetainCount((__bridge CFTypeRef) self.firstName)); //1
    [_firstName release];
//    NSLog(@"firstName refCount after dealloc = %ld", CFGetRetainCount((__bridge CFTypeRef) self.firstName)); //-1 (max)
    [_lastName release];
    [_birthDate release];
    [_followers release];
    [_following release];
    [_address release];
    [_city release]; //not neccessary - it's just getter
    [_country release]; //not neccessary - it's just getter
    [super dealloc];
}

-(NSString *)description {
//    return [[NSString stringWithFormat:@"\n%@;\n%@ %@", _userId, _firstName, _lastName]autorelease];
    NSMutableString *result = [[[NSMutableString alloc]init]autorelease];// if NSString - no need to autorelease
    [result appendString:[NSString stringWithFormat:
                          @"id:%@; name:%@ %@; birthdate:%@; address:%@; followersNum:%d; followingNum:%d; isContactUser:%@",
                          self.userId, self.firstName, self.lastName, [self getPrettyDate:_birthDate], self.compositeAddress,
                          (int)[self.followers count], (int)[self.following count], [self getBoolLiteral:[self isContactUser]]]];
    return result;
}

#pragma mark - Useful protected methods
//from extension in NGNUserProtectedMethods.h
-(NSString *)getBoolLiteral:(BOOL)boolValue {
    return (boolValue ? @"Yes" : @"No");
}

//from extension in NGNUserProtectedMethods.h
-(NSString *)getPrettyDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"LL/dd/yyyy"];
    NSString *result = [formatter stringFromDate:date];
    [formatter release];
    return result;
}

//getUserId
-(NSNumber *)userId{
    @synchronized (self) { //necessary synchronized block here - atomic behavior
        return [[_userId retain] autorelease]; // is atomic variable - always autorelease
    }
}

//setUserId
-(void)setUserId:(NSNumber *)userId{
    @synchronized (self) {
        // we could do it like that
        [userId retain];
        [_userId release];
        _userId = userId;
    }
}

//getFirstName
-(NSMutableString *)firstName {
    // here we are able to not to retain and autorelease, but in that case we should
    // to retain and release reference manually somewhere in our code. Hard choice...
    //    return [[_firstName retain] autorelease];
    return _firstName;
}

//setFirstName
-(void)setFirstName:(NSMutableString *)firstName {
    // or like that with the same effect
    if (_firstName != firstName) {
        [_firstName release];
        _firstName = [firstName retain];
    }
}

//getLastName
-(NSMutableString *)lastName{
    //    return [[_lastName retain] autorelease];
    return _lastName;
}

//setLastName
-(void)setLastName:(NSMutableString *)lastName {
    if(_lastName != lastName) {
        [_lastName release];
        _lastName = [lastName mutableCopy]; // usual copy returns immutable copy of object (and we have mutable version),
                                            // and so, with usual copy, we won't be able to change that string
    }
}

//getFollowers
-(NSArray *)followers {
    @synchronized (self) {
//        return [[_followers retain] autorelease]; //always autorelease if atomic
        return [[_followers copy] autorelease]; //or we could do like this if we need to return immutable object
    }
}

//getFollowing
- (NSArray *)following {
//    return _following;
    return [[_following copy]autorelease]; //or we could do like this if we need to return immutable object
}

// There is no need in setters, because properties are readonly, but, if we need, so there they are...
////setFollowers
//-(void)setFollowers:(NSMutableArray *)followers {
//    @synchronized (self) {
//        if (_followers != followers) {
//            [_followers release];
//            _followers = [followers mutableCopy];
//        }
//    }
//}
//
////setFollowing
//-(void)setFollowing:(NSMutableArray *)following {
//        if (_following != following) {
//            [_following release];
//            _following = [following retain];
//        }
//}

// get city name from address dictionary
-(NSString *)city {
    if (self.address == nil) {
        // key is copying and value is retaining in dictionary, and
        // if you want to get permanent reference to value, you should to
        // retain value reference manually.
        return nil;
    }
//    return [self.address valueForKey:@"city"];//calling class will decide if he wants to become an owner of returned object
    return [[self.address[@"city"] copy] autorelease];
}

// get country name from address dictionary
-(NSString *)country {
    if (self.address == nil) {
        return nil;
    }
    return [self.address valueForKey:@"country"];//calling class will decide if he wants to become an owner of returned object
}

//rewritten getter for contactUser field
-(BOOL)isContactUser {
    return _contactUser;// BOOL is primitive type, so there's no need to retain or copy object
}

@end


#pragma mark - Common user maintenance
@implementation NGNUser (NGNCommonUserMaintenance)
// writes full name in console
-(void)printFullName {
    NSLog(@"%@ %@", self.lastName, self.firstName);
}
@end

#pragma mark - Follwers/following maintenance
@implementation NGNUser (NGNUserFollowersMaintanance)

//In these add/remove methods I call getter/setter that returns NSArray, as compiler think,
//but really returns NSMutableArray, and we could change it! To avoid such situation, getters should
//to return immutable copies of arrays, and we should to use ivars, not getters, in add/remove methods!

// adding friend into followers array
-(void)addFollower:(NGNUser *)follower {
    if (_followers == nil) {
        _followers = [[NSMutableArray alloc]init];
    }
//    [(NSMutableArray *)self.followers addObject:follower];
    [(NSMutableArray *)_followers addObject:follower]; //if we use immutable copies in getters
                                                         // to close an access from outside
}

// remove friend from followers array
-(void)removeFollower:(NGNUser *)follower {
//    [(NSMutableArray *)self.followers removeObject:follower];
    [(NSMutableArray *)_followers removeObject:follower]; //if we use immutable copies in getters
                                                            //to close an access from outside
}

// returns bool value
-(BOOL)isFollowerPerson:(NGNUser *)person {
    return [self.followers containsObject:person];
}

// adding friend into following
-(void)addFollowing:(NGNUser *)following{
    if (_following == nil) {
        _following = [[NSMutableArray alloc]init];
    }
//    [(NSMutableArray *)self.following addObject:following];
    [(NSMutableArray *)_following addObject:following]; //if we use immutable copies in getters
                                                          //to close an access from outside
}

// removing friend from following
-(void)removeFollowing:(NGNUser *)following{
//    [(NSMutableArray *)self.following removeObject:following];
    [(NSMutableArray *)_following removeObject:following]; //if we use immutable copies in getters
                                                               //to close an access from outside
}

// returns bool value
-(BOOL)isFollowingPerson:(NGNUser *)person{
//    return [self.following containsObject:person]
    //or maybe better like this
    return [_following containsObject:person];
}

@end

//#pragma mark - rewritten accsessors/mutators
//@implementation NGNUser (NGNUserRewriteAcsessorsMutators)
////getUserId
//-(NSNumber *)userId{
//    @synchronized (self) { //necessary synchronized block here - atomic behavior
//        return [[_userId retain] autorelease]; // here we are able to not to retain and autorelease, but in that case we should
//                                               // to retain and release reference manually somewhere in our code. Hard choice...
//                                               // is atomic variable - always autorelease
////        return _userId;
//    }
//}
//
////setUserId
//-(void)setUserId:(NSNumber *)userId{
//    @synchronized (self) {
//        // we could do it like that
//        [userId retain];
//        [_userId release];
//        _userId = userId;
//    }
//}
//
////getFirstName
//-(NSMutableString *)firstName{
////    return [[_firstName retain] autorelease];
//    return _firstName;
//}
//
////setFirstName
//-(void)setFirstName:(NSMutableString *)firstName{
//    // or like that
//    if (_firstName != firstName) {
//        [_firstName release];
//        _firstName = [firstName retain];
//    }
//}
//
////getLastName
//-(NSMutableString *)lastName{
////    return [[_lastName retain] autorelease];
//    return _lastName;
//}
//
////setLastName
//-(void)setLastName:(NSMutableString *)lastName {
//    if(_lastName != lastName) {
//        [_lastName release];
//        _lastName = [lastName mutableCopy]; // usual copy returns immutable copy of object (and we have mutable version),
//                                            // and we won't be able to change that string
//    }
//}
//
////getFollowers
//-(NSMutableArray *)followers{
//    @synchronized (self) {
//        return [[_followers retain] autorelease]; //if atomic - always autorelease
////        return _followers;
//    }
//}
//
//- (NSArray *)following {
//    return [[_following mutableCopy]autorelease];
//}
//
//////setFollowers
////-(void)setFollowers:(NSMutableArray *)followers{
////    @synchronized (self) {
////        if (_followers != followers) {
////            [_followers release];
////            _followers = [followers mutableCopy];
////        }
////    }
////}
////
//////setFollowing
////-(void)setFollowing:(NSMutableArray *)following {
////        if (_following != following) {
////            [_following release];
////            _following = [following retain];
////        }
////}
//
//// get city name from address dictionary
//-(NSString *)city {
////    NSString *city = nil;
//    if (self.address == nil) {
////        city = [[[self.address valueForKey:@"city"]retain]autorelease]; // in dictionary key is copying and value is retaining, and
//                                                                        // if you want to get reference to value, you should to
//                                                                        // retain value reference manually.
//        return nil;
//    }
//    return [self.address valueForKey:@"city"];//calling class will decide if he wants to become an owner of returned object
//}
//
//// get country name from address dictionary
//-(NSString *)country {
////    NSString *country = nil;
//    if (self.address == nil) {
////        country = [[[self.address valueForKey:@"country"]retain]autorelease]; //?
//        return nil;
//    }
//    return [self.address valueForKey:@"country"];//calling class will decide if he wants to become an owner of returned object
//}
//
////rewritten getter for contactUser field
//-(BOOL)isContactUser{
//    return _contactUser;// BOOL is primitive type, so there's no need to retain or copy object
//}
//
//@end




