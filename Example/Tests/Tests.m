//
//  AYRuntimeTests.m
//  AYRuntimeTests
//
//  Created by Alan Yeh on 08/02/2016.
//  Copyright (c) 2016 Alan Yeh. All rights reserved.
//

@import XCTest;
#import <AYRuntime/AYRuntime.h>

#import "AYTestSwizzleClass.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBlockDescription{
    BOOL(^testBlock)(BOOL, id) = ^BOOL(BOOL animated, id object) {
        return YES;
    };
    
    AYBlockSignature *blockSignature = [[AYBlockSignature alloc] initWithBlock:testBlock];
    NSMethodSignature *methodSignature = blockSignature.signature;
    
    XCTAssertEqual(strcmp(methodSignature.methodReturnType, @encode(BOOL)), 0, @"return type wrong");
    
    const char *expectedArguments[] = {@encode(typeof(testBlock)), @encode(BOOL), @encode(id)};
    for (int i = 0; i < blockSignature.signature.numberOfArguments; i++) {
        XCTAssertEqual(strcmp([blockSignature.signature getArgumentTypeAtIndex:i], expectedArguments[i]), 0, @"Argument %d wrong", i);
    }
}

- (void)testMethodReplace{
    AYTestSwizzleClass *testObject = [[AYTestSwizzleClass alloc] init];
    
    NSString *originalClassString = [AYTestSwizzleClass hello:@"Alan"];
    XCTAssertEqualObjects(originalClassString, @"From class: Hello Alan");
    
    NSString *originalInstanceString = [testObject hello:@"Alan"];
    XCTAssertEqualObjects(originalInstanceString, @"From instance: Hello Alan");
    
    __block IMP classImp = class_replaceClassMethodWithBlock([AYTestSwizzleClass class], @selector(hello:), ^NSString *(AYTestSwizzleClass *blockSelf, NSString *str){
        XCTAssertEqualObjects(blockSelf, [AYTestSwizzleClass class], @"blockSelf is wrong");
        return [@"Hooked: " stringByAppendingString:classImp(blockSelf, @selector(hello:), str)];
    });
    
    XCTAssertEqualObjects([AYTestSwizzleClass hello:@"Alan"], @"Hooked: From class: Hello Alan");
    XCTAssertEqualObjects([testObject hello:@"Alan"], @"From instance: Hello Alan");
    
    __block IMP instanceImp = class_replaceInstanceMethodWithBlock([AYTestSwizzleClass class], @selector(hello:), ^NSString *(AYTestSwizzleClass *blockSelf, NSString *str){
        XCTAssertEqualObjects(blockSelf, testObject, @"blockSelf is wrong");
        return [@"Hooked: " stringByAppendingString:instanceImp(blockSelf, @selector(hello:), str)];
    });
    
    XCTAssertEqualObjects([AYTestSwizzleClass hello:@"Alan"], @"Hooked: From class: Hello Alan");
    XCTAssertEqualObjects([testObject hello:@"Alan"], @"Hooked: From instance: Hello Alan");
    
    
    XCTAssert(CGPointEqualToPoint(CGPointMake(2.0f, 2.0f), [testObject pointByAddingPoint:CGPointMake(1.0f, 1.0f)]), @"initial point wrong");
    
    typedef CGPoint(*pointImplementation)(id self, SEL _cmd, CGPoint point);
    
    __block pointImplementation implementation3 = (pointImplementation)class_replaceInstanceMethodWithBlock([AYTestSwizzleClass class], @selector(pointByAddingPoint:), ^CGPoint(AYTestSwizzleClass *blockSelf, CGPoint point) {
        XCTAssertEqualObjects(blockSelf, testObject, @"blockSelf is wrong");
        
        CGPoint originalPoint = implementation3(blockSelf, @selector(pointByAddingPoint:), point);
        return CGPointMake(originalPoint.x + 1.0f, originalPoint.y + 1.0f);
    });
    
    XCTAssert(CGPointEqualToPoint(CGPointMake(3.0f, 3.0f), [testObject pointByAddingPoint:CGPointMake(1.0f, 1.0f)]), @"initial point wrong");
    
}

- (void)testMethodSwizzling{
    AYTestSwizzleClass *testObject = [[AYTestSwizzleClass alloc] init];
    NSString *originalString = testObject.orginalString;
    
    class_swizzleSelector(AYTestSwizzleClass.class, @selector(orginalString), @selector(__hookedOriginalString));
    
    NSString *hookedString = testObject.orginalString;
    
    XCTAssertFalse([originalString isEqualToString:hookedString], @"originalDescription cannot be equal to hookedDescription.");
    XCTAssertEqualObjects(originalString, @"foo", @"originalString wrong.");
    XCTAssertTrue([hookedString isEqualToString:@"foobar"], @"hookedDescription should have suffix 'bar'.");
}

- (void)testBlockInvocation{
    CGPoint (^block)(CGPoint) = ^CGPoint(CGPoint point) {
        XCTAssert(CGPointEqualToPoint(CGPointMake(1.0, 1.0), point));
        return CGPointMake(point.x + 1.0f, point.y + 1.0f);
    };
    
    AYBlockInvocation *invocation = [AYBlockInvocation invocationWithBlock:block];
    CGPoint point = CGPointMake(1.0, 1.0);
    [invocation setArgument:&point atIndex:1];
    
    [invocation invoke];
    CGPoint result;
    [invocation getReturnValue:&result];
    XCTAssert(CGPointEqualToPoint(CGPointMake(2.0, 2.0), result));
}

- (void)testGetClassMethod{
    //Method forwarding = class_getInstanceMethod([AYTestSwizzleClass class], @selector(forwardingTargetForSelector:));
    //XCTAssert(forwarding == NULL);
    
    Method hello = class_getClassMethod([AYTestSwizzleClass class], @selector(hello:));
    XCTAssert(hello != NULL && method_getName(hello) == @selector(hello:));
}

- (void)testAssociatedObject{
    AYTestSwizzleClass *testObject = [[AYTestSwizzleClass alloc] init];
    objc_AssociationKey(AY_TEST_SWIZZLE_ASSOCIATION_KEY);
    NSString *str = objc_getAssociatedDefaultObject(testObject, AY_TEST_SWIZZLE_ASSOCIATION_KEY, @"abc", OBJC_ASSOCIATION_COPY);
    XCTAssert([str isEqualToString:@"abc"]);
    
    NSString *str2 = objc_getAssociatedObject(testObject, AY_TEST_SWIZZLE_ASSOCIATION_KEY);
    XCTAssert([str2 isEqualToString:@"abc"]);
    
    objc_AssociationKey(AY_TEST_SWIZZLE_ASSOCIATION_KEY2);
    NSString *str3 = objc_getAssociatedDefaultObjectBlock(testObject, AY_TEST_SWIZZLE_ASSOCIATION_KEY2, OBJC_ASSOCIATION_COPY, ^id{
        return @"aaa";
    });
    XCTAssert([str3 isEqualToString:@"aaa"]);
    
    NSString *str4 = objc_getAssociatedObject(testObject, AY_TEST_SWIZZLE_ASSOCIATION_KEY2);
    XCTAssert([str4 isEqualToString:@"aaa"]);
}

- (void)testDeallocNotifier{
    id ex = [self expectationWithDescription:@""];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AYTestSwizzleClass *class = [AYTestSwizzleClass new];
        [class ay_notifyWhenDealloc:^{
            [ex fulfill];
        }];
    });
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

@end

