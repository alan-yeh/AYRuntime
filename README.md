# AYRuntime

[![CI Status](http://img.shields.io/travis/alan-yeh/AYRuntime.svg?style=flat)](https://travis-ci.org/alan-yeh/AYRuntime)
[![Version](https://img.shields.io/cocoapods/v/AYRuntime.svg?style=flat)](http://cocoapods.org/pods/AYRuntime)
[![License](https://img.shields.io/cocoapods/l/AYRuntime.svg?style=flat)](http://cocoapods.org/pods/AYRuntime)
[![Platform](https://img.shields.io/cocoapods/p/AYRuntime.svg?style=flat)](http://cocoapods.org/pods/AYRuntime)

## 引用
　　使用[CocoaPods](http://cocoapods.org)可以很方便地引入AYRuntime。Podfile添加AYRuntime的依赖。

```ruby
pod "AYRuntime"
```

## 简介
　　AYRuntime中包含了一些关于Runtime的类库。

## AYBlockInvocation
　　AYBlockInvocation可以很方便地动态调用block。用法与NSInvocation非常相似。

```Objective-C
    CGPoint (^block)(CGPoint) = ^CGPoint(CGPoint point) {
        XCTAssert(CGPointEqualToPoint(CGPointMake(1.0, 1.0), point));
        return CGPointMake(point.x + 1.0f, point.y + 1.0f);
    };
    
    AYBlockInvocation *invocation = [AYBlockInvocation invocationWithBlock:block];
    CGPoint point = CGPointMake(1.0, 1.0);
    //NSInvocation的参数从2开始，而AYBlockInvocation的参数从1开始
    [invocation setArgument:&point atIndex:1];
    
    [invocation invoke];
    CGPoint result;
    [invocation getReturnValue:&result];
    XCTAssert(CGPointEqualToPoint(CGPointMake(2.0, 2.0), result));
```

## AYDeallocNotifier
　　AYDeallocNotifier利用runtime，在对象销毁时，可以去执行一些动作。

```objective-c
    id ex = [self expectationWithDescription:@""];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AYTestSwizzleClass *object = [AYTestSwizzleClass new];
        [object ay_notifyWhenDealloc:^{
            [ex fulfill];
        }];
    });
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
```

## runtime.h
```objective-c
#define objc_AssociationKey(key) static const void * const key = &key
#define objc_AssociationKeyAndNotes(key, notes) static const void * const key = &key

FOUNDATION_EXPORT void class_swizzleSelector(Class class, SEL originalSelector, SEL newSelector);

FOUNDATION_EXPORT void class_enumerateMethodList(Class class, void(^enumerator)(Class class, Method method));

FOUNDATION_EXPORT IMP class_replaceClassMethodWithBlock(Class cls, SEL originalSelector, id block);

FOUNDATION_EXPORT IMP class_replaceInstanceMethodWithBlock(Class cls, SEL originalSelector, id block);

FOUNDATION_EXPORT Method class_getClassMethod(Class cls, SEL selector);

FOUNDATION_EXPORT Method class_getInstanceMethod(Class cls, SEL selector);

FOUNDATION_EXPORT id objc_getAssociatedDefaultObject(id object, const void *key, id defaultObject, objc_AssociationPolicy policy);

FOUNDATION_EXPORT id objc_getAssociatedDefaultObjectBlock(id object, const void *key, objc_AssociationPolicy policy, id (^defaultObject)());
```

## License

AYRuntime is available under the MIT license. See the LICENSE file for more info.
