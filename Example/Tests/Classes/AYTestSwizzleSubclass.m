//
//  AYTestSwizzleSubclass.m
//  AYRuntime
//
//  Created by PoiSon on 16/8/2.
//  Copyright © 2016年 Alan Yeh. All rights reserved.
//

#import "AYTestSwizzleSubclass.h"

@implementation AYTestSwizzleSubclass
#pragma mark - Initialization

- (id)init
{
    if (self = [super init]) {
        // Initialization code
    }
    return self;
}

#pragma mark - Instance methods

+ (BOOL)passesTest
{
    return YES;
}

#pragma mark - Memory management

- (void)dealloc
{
    
}

#pragma mark - Private category implementation ()

@end
