//
//  AYTestSeizzleClass.m
//  AYRuntime
//
//  Created by PoiSon on 16/8/2.
//  Copyright © 2016年 Alan Yeh. All rights reserved.
//

#import "AYTestSwizzleClass.h"

@implementation AYTestSwizzleClass
#pragma mark - Initialization

- (id)init
{
    if (self = [super init]) {
        // Initialization code
    }
    return self;
}

#pragma mark - Instance methods



- (NSString *)helloWorldStringFromString:(NSString *)string
{
    return [@"Hello World" stringByAppendingFormat:@" %@", string];
}



- (NSString *)stringTwo
{
    return @"foo";
}

- (NSString *)__prefixedHookedStringTwo
{
    NSString *original = [self __prefixedHookedStringTwo];
    return [original stringByAppendingString:@"bar"];
}

+ (NSString *)stringThree
{
    return @"foo";
}

+ (NSString *)__prefixedHookedStringThree
{
    NSString *original = [self __prefixedHookedStringThree];
    return [original stringByAppendingString:@"bar"];
}

- (NSString *)stringByJoiningString:(NSString *)string withWith:(NSString *)suffix
{
    return [string stringByAppendingString:suffix];
}

- (NSString *)__prefixedHookedStringByJoiningString:(NSString *)string withWith:(NSString *)suffix
{
    NSString *original = [self __prefixedHookedStringByJoiningString:string withWith:suffix];
    return [original stringByAppendingString:@"bar"];
}

- (NSString *)__prefixedHookedStringFive
{
    return @"foo";
}

+ (BOOL)passesTest
{
    return NO;
}

#pragma mark - Memory management

- (void)dealloc
{
    
}

#pragma mark - Private category implementation ()


- (NSString *)hello:(NSString *)str{
    return [@"From instance: Hello " stringByAppendingString:str];
}

+ (NSString *)hello:(NSString *)str{
    return [@"From class: Hello " stringByAppendingString:str];
}

- (CGPoint)pointByAddingPoint:(CGPoint)point
{
    return CGPointMake(point.x + 1.0f, point.y + 1.0f);
}

- (NSString *)orginalString{
    return @"foo";
}

- (NSString *)__hookedOriginalString{
    NSString *original = [self __hookedOriginalString];
    return [original stringByAppendingString:@"bar"];
}
@end
