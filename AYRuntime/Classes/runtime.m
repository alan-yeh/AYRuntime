//
//  runtime.m
//  AYRuntime
//
//  Created by Alan Yeh on 16/8/2.
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


void class_enumerateMethodList(Class class, void(^enumerator)(Class class, Method method)){
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

Method class_getClassMethod(Class cls, SEL selector){
    return class_getInstanceMethod(object_getClass(cls), selector);
}

Method class_getInstanceMethod(Class cls, SEL selector){
    Method result = NULL;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        if (method_getName(methods[i]) == selector) {
            result = methods[i];
            break;
        }
    }
    free(methods);
    return result;
}

id objc_getAssociatedDefaultObject(id object, const void *key, id defaultObject, objc_AssociationPolicy policy){
    id obj = objc_getAssociatedObject(object, key);
    if (obj == nil && defaultObject != nil) {
        obj = defaultObject;
        objc_setAssociatedObject(object, key, obj, policy);
    }
    return obj;
}

id objc_getAssociatedDefaultObjectBlock(id object, const void *key, objc_AssociationPolicy policy, id (^defaultObject)()){
    id obj = objc_getAssociatedObject(object, key);
    if (obj == nil && defaultObject != nil) {
        obj = defaultObject();
        if (obj != nil) {
            objc_setAssociatedObject(object, key, obj, policy);
        }
    }
    return obj;
}