//
//  AYDeallocNotifier.h
//  AYRuntime
//
//  Created by Alan Yeh on 16/8/3.
//
//

#import <Foundation/Foundation.h>

@interface AYDeallocNotifier : NSObject
@property (nonatomic, strong) NSMutableArray *callbacks;
+ (void)notifyWhenInstanceDelloc:(id)anInstance withCallback:(void (^)(void))callback;
@end

@interface NSObject (AYDeallocNotifier)
- (void)ay_notifyWhenDealloc:(void (^)(void))notification;/**< 当dealloc时，执行${notification}. */
@end