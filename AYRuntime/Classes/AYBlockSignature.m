//
//  AYBlockSignature.m
//  AYRuntime
//
//  Created by PoiSon on 16/8/2.
//
//

#import "AYBlockSignature.h"

@implementation AYBlockSignature

+ (instancetype)signatureWithBlock:(id)block{
    return [[self alloc] initWithBlock:block];
}


- (id)initWithBlock:(id)block{
    if (self = [super init]) {
        _block = block;
        
        struct AYBlockLiteral *blockRef = (__bridge struct AYBlockLiteral *)block;
        _flags = blockRef->flags;
        _size = blockRef->descriptor->size;
        
        if (_flags & AYBlockSignatureFlagsHasSignature) {
            void *signatureLocation = blockRef->descriptor;
            signatureLocation += sizeof(unsigned long int);
            signatureLocation += sizeof(unsigned long int);
            
            if (_flags & AYBlockSignatureFlagsHasCopyDispose) {
                signatureLocation += sizeof(void(*)(void *dst, void *src));
                signatureLocation += sizeof(void (*)(void *src));
            }
            
            const char *signature = (*(const char **)signatureLocation);
            _signature = [NSMethodSignature signatureWithObjCTypes:signature];
        }
    }
    return self;
}

- (BOOL)isCompatibleToMethodSignature:(NSMethodSignature *)methodSignature{
    if (_signature.numberOfArguments != methodSignature.numberOfArguments + 1) {
        return NO;
    }
    
    if (strcmp(_signature.methodReturnType, methodSignature.methodReturnType) != 0) {
        return NO;
    }
    
    for (int i = 0; i < methodSignature.numberOfArguments; i++) {
        if (i == 1) {
            // SEL in method, IMP in block
            if (strcmp([methodSignature getArgumentTypeAtIndex:i], ":") != 0) {
                return NO;
            }
            
            if (strcmp([_signature getArgumentTypeAtIndex:i + 1], "^?") != 0) {
                return NO;
            }
        } else {
            if (strcmp([methodSignature getArgumentTypeAtIndex:i], [_signature getArgumentTypeAtIndex:i + 1]) != 0) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@: %@", [super description], _signature.description];
}

@end