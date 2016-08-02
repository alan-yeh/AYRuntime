//
//  AYBlockSignature.h
//  AYRuntime
//
//  Created by Alan Yeh on 16/8/2.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AYBlockSignatureFlags) {
    AYBlockSignatureFlagsHasCopyDispose = (1 << 25),
    AYBlockSignatureFlagsHasCtor = (1 << 26), // helpers have C++ code
    AYBlockSignatureFlagsIsGlobal = (1 << 28),
    AYBlockSignatureFlagsHasStret = (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    AYBlockSignatureFlagsHasSignature = (1 << 30)
};

@interface AYBlockSignature : NSObject

@property (nonatomic, readonly) AYBlockSignatureFlags flags;
@property (nonatomic, readonly) NSMethodSignature *signature;
@property (nonatomic, readonly) unsigned long int size;
@property (nonatomic, readonly) id block;

+ (instancetype)signatureWithBlock:(id)block;
- (instancetype)initWithBlock:(id)block;

- (BOOL)isCompatibleToMethodSignature:(NSMethodSignature *)methodSignature;
@end
