//
//  AYBlockInvocation.h
//  AYRuntime
//
//  Created by Alan Yeh on 16/8/2.
//
//

#import <Foundation/Foundation.h>
#import <AYRuntime/AYBlockSignature.h>

@interface AYBlockInvocation : NSObject
@property (readonly) AYBlockSignature *blockSignature;

+ (instancetype)invocationWithBlock:(id)block;
- (instancetype)initWithBlock:(id)block;

- (void)retainArguments;
@property (readonly) BOOL argumentsRetained;

- (void)getReturnValue:(void *)retLoc;
- (void)setArgument:(void *)argLoc atIndex:(NSInteger)idx;/**< Index should start at 1. */

- (void)invoke;
@end
