//
//  AYTestSeizzleClass.m
//  AYRuntime
//
//  Created by PoiSon on 16/8/2.
//  Copyright © 2016年 Alan Yeh. All rights reserved.
//

#import "AYTestSwizzleClass.h"

@implementation AYTestSwizzleClass

- (NSString *)hello:(NSString *)str{
    return [@"From instance: Hello " stringByAppendingString:str];
}

+ (NSString *)hello:(NSString *)str{
    return [@"From class: Hello " stringByAppendingString:str];
}

- (CGPoint)pointByAddingPoint:(CGPoint)point{
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
