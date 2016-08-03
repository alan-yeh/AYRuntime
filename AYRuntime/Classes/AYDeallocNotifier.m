//
//  AYDeallocNotifier.m
//  AYRuntime
//
//  Created by Alan Yeh on 16/8/3.
//
//

#import "AYDeallocNotifier.h"
#import "runtime.h"

@implementation AYDeallocNotifier
+ (void)notifyWhenInstanceDelloc:(id)anInstance withCallback:(void (^)(void))callback{
    objc_AssociationKeyAndNotes(AY_DEALLOC_NOTIFICATION_KEY, @"Store an object to target, when the target dealloc, this object is dealloc either.");
    AYDeallocNotifier *notifier = objc_getAssociatedDefaultObject(anInstance, AY_DEALLOC_NOTIFICATION_KEY, [AYDeallocNotifier new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [notifier.callbacks addObject:callback];
}

- (NSMutableArray *)callbacks{
    return _callbacks ?: (_callbacks = [NSMutableArray new]);
}

- (void)dealloc{
    for (void (^callback)(void) in self.callbacks) {
        callback();
    }
}
@end

@implementation NSObject (AYDeallocNotifier)
- (void)ay_notifyWhenDealloc:(void (^)(void))notification{
    [AYDeallocNotifier notifyWhenInstanceDelloc:self withCallback:notification];
}
@end