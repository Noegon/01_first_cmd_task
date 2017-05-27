//
//  NGNUser+NGNAddress.m
//  FirstTask
//
//  Created by user on 19.04.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "NGNUser+NGNAddress.h"

@implementation NGNUser (NGNAddress)
-(NSString *)compositeAddress {
    NSString *city = self.city;
    NSString *country = self.country;
    NSString *result = nil;

    if (self.address && (city || country)) {
        if (city && country) {
            result = [NSString stringWithFormat:@"city: %@; country %@", city, country];
        } else if (city && !country) {
            result = [NSString stringWithFormat:@"city: %@", self.city];
        } else if (!city && country) {
            result = [NSString stringWithFormat:@"country: %@", self.country];
        }
    } else {
        return @"unknown";
    }
    
//    NSLog(@"result refCount = %ld", CFGetRetainCount((__bridge CFTypeRef) result));
    return result; // here I have refCount = 1, so need I to retain it, or perceive object ref as unsafe_unretained?
                   // at the moment, result object it is in autorelease pool
}
@end
