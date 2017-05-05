//
//  NGNUserProtectedMethods.h
//  FirstTask
//
//  Created by user on 25.04.17.
//  Copyright © 2017 user. All rights reserved.
//

#import "NGNUser.h"

// here is declaration of protected methods, that wonn't be seen outside, but, after header file import,
// will be able to use in heirs

//@protocol NGNUserProtectedMethods <NSObject>
///**Returns boolean literal: yes or no*/
//-(NSString *)getBoolLiteral:(BOOL)boolValue;
//
///**Returns date in pretty format*/
//-(NSString *)getPrettyDate:(NSDate *)date;
//@end
//
//@interface NGNUser () <NGNUserProtectedMethods>
//@end

// but there is a variant without protocol - extension only
@interface NGNUser ()
/**Returns boolean literal: yes or no*/
- (NSString *)getBoolLiteral:(BOOL)boolValue;

/**Returns date in pretty format*/
- (NSString *)getPrettyDate:(NSDate *)date;
@end

// Main scheme of making protected methods
/*
 SuperClassProtectedMethods.h (protocol file):
 
 @protocol SuperClassProtectedMethods <NSObject>
 - (void) protectMethod:(NSObject *)foo;
 @end
 
 @interface SuperClass (ProtectedMethods) < SuperClassProtectedMethods >
 @end
 // or it could be extension, not cathegory
 @interface SuperClass () < SuperClassProtectedMethods >
 @end
 -------------------------------------------------------------------------
 SuperClass.m: (compiler will now force you to add protected methods)
 
 #import "SuperClassProtectedMethods.h"
 @implementation SuperClass
 - (void) protectedMethod:(NSObject *)foo {}
 @end
 -------------------------------------------------------------------------
 SubClass.m:
 
 #import "SuperClassProtectedMethods.h"
 // Subclass can now call the protected methods, but no external classes,
 // importing .h files will be able to see the protected methods.
*/
