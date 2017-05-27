//
//  NGNClass.m
//  FirstTask
//
//  Created by user on 20.04.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "NGNClass.h"

@implementation NGNClass
-(NSString *)description{
    return [[NSString stringWithFormat:@"%@; TestClass",[super description]]autorelease];
}
@end
