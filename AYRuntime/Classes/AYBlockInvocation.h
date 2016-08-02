//
//  AYBlockInvocation.h
//  Pods
//
//  Created by PoiSon on 16/8/2.
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

- (void)getReutrnValue:(void *)retLoc;
- (void)setArgument:(void *)argLoc atIndex:(NSInteger)idx;/** Index should begin at 1. */

- (void)invoke;
@end