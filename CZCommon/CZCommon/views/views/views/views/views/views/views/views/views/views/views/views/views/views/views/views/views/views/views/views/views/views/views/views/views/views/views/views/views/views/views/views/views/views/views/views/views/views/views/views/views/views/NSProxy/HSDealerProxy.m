//
//  HSDealerProxy.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/10.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "HSDealerProxy.h"
#import <objc/runtime.h>
@interface HSDealerProxy() {
    HSBookProvider      *_bookProvider;
    HSClothesProvider   *_clothesProvider;
    NSMutableDictionary *_methodMap;
}
@end

@implementation HSDealerProxy

+ (instancetype)dealerProxy {
    
    return [[HSDealerProxy alloc]init];
}

- (instancetype)init {
    
    _bookProvider    = [[HSBookProvider alloc]init];
    _clothesProvider = [[HSClothesProvider alloc]init];
    _methodMap       = [NSMutableDictionary dictionary];
    
    [self _registerMethodsWithTarget:_bookProvider];
    [self _registerMethodsWithTarget:_clothesProvider];
    return self;
}

#pragma mark ---- private method 
- (void)_registerMethodsWithTarget:(id)target {
    
    unsigned int numberOfMethods = 0;
    Method *methodList = class_copyMethodList([target class], &numberOfMethods);
    
    for (int i = 0; i < numberOfMethods; i++) {
        Method tempMethod = methodList[i];
        SEL temSel = method_getName(tempMethod);
        const char *tempMethodName = sel_getName(temSel);
        [_methodMap setObject:target forKey:[NSString stringWithUTF8String:tempMethodName]];
    }
    free(methodList);
}

#pragma mark ---- NSProxy override method
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSLog(@"%s",__FUNCTION__);
    NSString *methodName = NSStringFromSelector(sel);
    id target = _methodMap[methodName];
    if (target && [target respondsToSelector:sel]) {
        return [target methodSignatureForSelector:sel];
    }else {
        return [super methodSignatureForSelector:sel];
    }
}


- (void)forwardInvocation:(NSInvocation *)invocation {
    NSLog(@"%s",__FUNCTION__);
    SEL sel = invocation.selector;
    NSString *methodName = NSStringFromSelector(sel);
    id target = _methodMap[methodName];
    
    if (target && [target respondsToSelector:sel]) {
        [invocation invokeWithTarget:target];
    } else {
        [super forwardInvocation:invocation];
    }

}


@end






















