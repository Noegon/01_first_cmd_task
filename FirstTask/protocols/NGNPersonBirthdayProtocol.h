//
//  NGNUser+NGNPersonBirthday.h
//  FirstTask
//
//  Created by user on 19.04.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "NGNUser.h"

@protocol NGNPersonBirthdayProtocol <NSObject>
@optional
- (void)happyBirthday;
@required
/** insert date in format mm/dd/yyyy */
- (void)setBirthDayFromString:(NSString*)dateString;
- (BOOL)isTodayBirthDate;
@end
