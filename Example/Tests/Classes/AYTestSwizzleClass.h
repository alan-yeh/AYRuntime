//
//  AYTestSeizzleClass.h
//  AYRuntime
//
//  Created by PoiSon on 16/8/2.
//  Copyright © 2016年 Alan Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYTestSwizzleClass : NSObject



- (NSString *)stringTwo;
- (NSString *)__prefixedHookedStringTwo;

+ (NSString *)stringThree;
+ (NSString *)__prefixedHookedStringThree;

- (NSString *)stringByJoiningString:(NSString *)string withWith:(NSString *)suffix;
- (NSString *)__prefixedHookedStringByJoiningString:(NSString *)string withWith:(NSString *)suffix;

- (NSString *)__prefixedHookedStringFive;

+ (BOOL)passesTest;

- (NSString *)hello:(NSString *)str;
+ (NSString *)hello:(NSString *)str;


- (CGPoint)pointByAddingPoint:(CGPoint)point;


- (NSString *)orginalString;
- (NSString *)__hookedOriginalString;
@end
