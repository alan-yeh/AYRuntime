//
//  runtime.h
//  AYRuntime
//
//  Created by Alan Yeh on 16/8/2.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define objc_AssociationKey(key) static const void * const key = &key
#define objc_AssociationKeyAndNotes(key, notes) static const void * const key = &key
/**
 * Exechange method implementations.
 */
FOUNDATION_EXPORT void class_swizzleSelector(Class class, SEL originalSelector, SEL newSelector);

/**
 *  Enumerate class methods.
 */
FOUNDATION_EXPORT void class_enumerateMethodList(Class class, void(^enumerator)(Class class, Method method));

/**
 * Replaces implementation of method in class for originalSelector with block.
 * if originalSelector's argument list is (id self, SEL _cmd, ...), then block's argument list must be (id self, ...)
 */
FOUNDATION_EXPORT IMP class_replaceClassMethodWithBlock(Class cls, SEL originalSelector, id block);

/**
 * Replaces implementation of method in instance for originalSelector with block.
 * if originalSelector's argument list is (id self, SEL _cmd, ...), then block's argument list must be (id self, ...)
 */
FOUNDATION_EXPORT IMP class_replaceInstanceMethodWithBlock(Class cls, SEL originalSelector, id block);

/**
 *  Return class method defind in class.
 */
FOUNDATION_EXPORT Method class_getClassMethod(Class cls, SEL selector);

/**
 *  Return class method defind in class instance.
 */
FOUNDATION_EXPORT Method class_getInstanceMethod(Class cls, SEL selector);

/**
 *  Returns the value associated with a given object for a given key.
 *  
 *  If the return value is nil, then will call "objc_setAssociatedObject" with given argument
 */
FOUNDATION_EXPORT id objc_getAssociatedDefaultObject(id object, const void *key, id defaultObject, objc_AssociationPolicy policy);

/**
 *  Returns the value associated with a given object for a given key.
 *
 *  If the return value is nil, then will call "objc_setAssociatedObject" with given argument and value returned from defaultObject()
 */
FOUNDATION_EXPORT id objc_getAssociatedDefaultObjectBlock(id object, const void *key, objc_AssociationPolicy policy, id (^defaultObject)());