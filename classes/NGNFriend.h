//
//  Friend.h
//  FirstTask
//
//  Created by user on 22.04.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "NGNUser.h"

@interface NGNFriend: NGNUser
@property(nonatomic, copy)NSNumber *blocked;

- (BOOL)isBlocked;
@end
