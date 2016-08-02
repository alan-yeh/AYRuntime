//
//  AYBlockSignature.h
//  AYRuntime
//
//  Created by PoiSon on 16/8/2.
//
//

#import <Foundation/Foundation.h>

struct AYBlockLiteral {
    void *isa; // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct block_descriptor {
        unsigned long int reserved;	// NULL
        unsigned long int size;         // sizeof(struct Block_literal_1)
        // optional helper functions
        void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
        void (*dispose_helper)(void *src);             // IFF (1<<25)
        // required ABI.2010.3.16
        const char *signature;                         // IFF (1<<30)
    } *descriptor;
    // imported variables
};

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
