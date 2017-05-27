//
//  NGNUser+NGNPersonBirthday.m
//  FirstTask
//
//  Created by user on 19.04.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "NGNUser+NGNPersonBirthday.h"
 
@implementation NGNUser (NGNPersonBirthday)

-(void)setBirthDayFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"LL/dd/yyyy"];
    self.birthDate = [formatter dateFromString:dateString]; //already in autorelease pool, but retains by birthDate setter
    [formatter release]; // here I release local object created by alloc-init methods
}

-(BOOL)isTodayBirthDate {
    if (self.birthDate == nil) {
        NSLog(@"%@", @"birth date is nil! Please, insert birth date");
        return NO;
    }
    
    NSDate *currentDate = [NSDate date]; //autoreleased
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentDateComponents = [calendar components:NSUIntegerMax fromDate:currentDate]; //autoreleased?
    NSDateComponents *birthdayDateComponents = [calendar components:NSUIntegerMax fromDate:self.birthDate]; //autoreleased?
    
    BOOL result = (currentDateComponents.month == birthdayDateComponents.month &&
                   currentDateComponents.day == currentDateComponents.day);
//        NSLog(@"currentDayComponents refCount = %ld", CFGetRetainCount((__bridge CFTypeRef) currentDateComponents)); //res=1
//        NSLog(@"birthdayDateComponents refCount = %ld", CFGetRetainCount((__bridge CFTypeRef) birthdayDateComponents)); //res=1
//    here I cannot release memory (currentDateComponents, birthdayDateComponents). Why? If they autoreleasing, how can I see it?
//    There's no any information in heder-file=(
//    [currentDateComponents release]; //refcount is 1 here
//    [birthdayDateComponents release]; //refcount is 1 here
    [calendar release]; // here I release local object created by alloc-init methods
    return result;
}
@end
