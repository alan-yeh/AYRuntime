//
//  runtime.h
//  Pods
//
//  Created by PoiSon on 16/8/2.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef void(^AYMethodEnumertor)(Class class, Method method);

/**
 * Exechange method implementations.
 */
void class_swizzleSelector(Class class, SEL originalSelector, SEL newSelector);


/**
 *  Enumerate class methods.
 */
void class_enumerateMethodList(Class class, AYMethodEnumertor enumerator);

/**
 * Replaces implementation of method in class for originalSelector with block.
 * if originalSelector's argument list is (id self, SEL _cmd, ...), then block's argument list must be (id self, ...)
 */
IMP class_replaceClassMethodWithBlock(Class class, SEL originalSelector, id block);

/**
 * Replaces implementation of method in instance for originalSelector with block.
 * if originalSelector's argument list is (id self, SEL _cmd, ...), then block's argument list must be (id self, ...)
 */
IMP class_replaceInstanceMethodWithBlock(Class class, SEL originalSelector, id block);