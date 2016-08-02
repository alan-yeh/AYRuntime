//
//  AYBlockInvocation.m
//  AYRuntime
//
//  Created by Alan Yeh on 16/8/2.
//
//

#import "AYBlockInvocation.h"

@implementation AYBlockInvocation{
    NSInvocation *_invocation;
}

+ (instancetype)invocationWithBlock:(id)block{
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id)block{
    if (self = [super init]) {
        _blockSignature = [AYBlockSignature signatureWithBlock:block];
        _invocation = [NSInvocation invocationWithMethodSignature:_blockSignature.signature];
        [_invocation setTarget:[block copy]];
    }
    return self;
}

- (void)retainArguments{
    [_invocation retainArguments];
}

- (BOOL)argumentsRetained{
    return [_invocation argumentsRetained];
}

- (void)getReturnValue:(void *)retLoc{
    [_invocation getReturnValue:retLoc];
}

- (void)setArgument:(void *)argLoc atIndex:(NSInteger)idx{
    [_invocation setArgument:argLoc atIndex:idx];
}

- (void)invoke{
    [_invocation invoke];
}

@end
