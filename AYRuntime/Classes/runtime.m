//
//  runtime.m
//  Pods
//
//  Created by PoiSon on 16/8/2.
//
//

#import "runtime.h"

void class_swizzleSelector(Class class, SEL originalSelector, SEL newSelector){
    Method origMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    if(class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(class, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}


void class_enumerateMethodList(Class class, AYMethodEnumertor enumerator){
    NSCParameterAssert(class != nil && enumerator != nil);
    
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(class, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i ++) {
        Method method = methods[i];
        enumerator(class, method);
    }
    free(methods);
}

IMP class_replaceClassMethodWithBlock(Class class, SEL originalSelector, id block){
    NSCParameterAssert(class != nil && originalSelector != NULL && block != nil);
    Method method = class_getClassMethod(class, originalSelector);
    NSCAssert(method != NULL, @"%@ does not response ro selector:%@", NSStringFromClass(class), NSStringFromSelector(originalSelector));
    
    IMP newImplementation = imp_implementationWithBlock(block);
    
    return method_setImplementation(method, newImplementation);
}

IMP class_replaceInstanceMethodWithBlock(Class class, SEL originalSelector, id block){
    NSCParameterAssert(class != nil && originalSelector != NULL && block != nil);
    Method method = class_getInstanceMethod(class, originalSelector);
    NSCAssert(method != NULL, @"Instance of %@ does not response ro selector:%@", NSStringFromClass(class), NSStringFromSelector(originalSelector));
    
    IMP newImplementation = imp_implementationWithBlock(block);
    
    return method_setImplementation(method, newImplementation);
}
