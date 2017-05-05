//
//  main.m
//  FirstTask
//
//  Created by user on 18.04.17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGNUser.h"
#import "NGNFriend.h"
#import "NGNUser+NGNAddress.h"
#import "NGNUser+NGNPersonBirthday.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray *names = @[@"Alex", @"Tanya", @"Paul", @"Donny", @"Chris", @"Roxana", @"Anthony", @"Bogdan", @"Gregory", @"Dmitry"];
        NSArray *surnames = @[@"Stafeyev", @"Kublashvili", @"Pott", @"Draco", @"Ree", @"Babajan", @"Stark", @"Kess", @"Rasputin", @"Medvedev"];
        NSDictionary *everyonesAddress = @{@"city":@"Gomel", @"country":@"Belarus", @"postCode":@"246000"};
        
        NSMutableArray *users = [[NSMutableArray alloc]initWithCapacity:10];
        
        for (int i = 0; i < [names count]; i++) {
            [users addObject:[NGNUser userWithId:[NSNumber numberWithInt:(i+1)]
                                       firstName:[names objectAtIndex:i]
                                        lastName:[surnames objectAtIndex:i]]];
            [(NGNUser *)[users objectAtIndex:i] setAddress:everyonesAddress];
            // some birthday hardcode... mm/dd/yyyy
            [[users objectAtIndex:i] setBirthDayFromString:[NSString stringWithFormat: @"%d/%d/%d", (i+1), (i+2), (1985+i)]];
//            NSMutableArray *friends = [[NSMutableArray alloc]init];
            for (int j = (int)([names count]-1); i <= j; j--) {
                NGNFriend *friend = [NGNFriend userWithId:[NSNumber numberWithInt:(200 + j)]
                                                firstName:[names objectAtIndex:j]
                                                 lastName:[surnames objectAtIndex:j]];
                
                [(NGNUser *)[users objectAtIndex:i] addFollower: friend];
                [(NGNUser *)[users objectAtIndex:i] addFollowing: friend];
//                [friends addObject:[NGNFriend userWithId:[NSNumber numberWithInt:(200 + j)]
//                                               firstName:[names objectAtIndex:j]
//                                                lastName:[surnames objectAtIndex:j]]];
            }
//            [(NGNUser *)[users objectAtIndex:i] setFollowers:friends];
//            [(NGNUser *)[users objectAtIndex:i] setFollowing:friends];
//            [friends release];
        }
        
        NGNFriend *testUser = [[NGNFriend alloc] initWithUserId:@101];
        NSDictionary *testAddrDict = @{@"country":@"Great Britain"};
        NSDate *testDate = [NSDate date];
        testUser.address = testAddrDict;
        testUser.birthDate = testDate;
//        NSLog(@"testUser refCount after alloc = %ld", CFGetRetainCount((__bridge CFTypeRef) testUser)); //res - 1
        [users addObject:testUser];
//        NSLog(@"testUser refCount after adding to array = %ld", CFGetRetainCount((__bridge CFTypeRef) testUser)); //res - 2
        
        // conclusion:
        // objects in NSArray retains ref count;
        // key objects in NSDictionary make copy;
        // value objects in NSDictionary retains ref count;
        
        [testUser addFollower:[[[NGNUser alloc]initWithUserId:@222]autorelease]];
//        [testUser.following addObject:[[NGNUser alloc]initWithUserId:@233]]; //now we return really immutable object!!!
        
        NSLog(@"%@", users);
        NSLog(@"is today testUser's birthday: %d", [testUser isTodayBirthDate]); // result is always 1 because testUser birthday
                                                                                 // always will be today
        NSLog(@"%@", @"Git check!"); //check for initial git commit
        
        [users release];
        [testUser release];
        
    }
    return 0;
}
