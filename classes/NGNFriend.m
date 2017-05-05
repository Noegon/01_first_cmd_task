//
//  Friend.m
//  FirstTask
//
//  Created by user on 22.04.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "NGNFriend.h"
#import "NGNUserProtectedMethods.h"

@implementation NGNFriend

-(BOOL)isBlocked {
//    return ([self.blocked integerValue] > 0) ? YES : NO;
    // or like that
    return self.blocked.integerValue > 0;
}

-(NSString *)description {
    NSMutableString *result = [[[super description] mutableCopy]autorelease];
    [result appendString:[NSString stringWithFormat:@" isBlocked:%@;\n", [self getBoolLiteral:[self isBlocked]]]];
    return result;
}

-(void)dealloc {
    [_blocked release];
    [super dealloc];
}
@end
