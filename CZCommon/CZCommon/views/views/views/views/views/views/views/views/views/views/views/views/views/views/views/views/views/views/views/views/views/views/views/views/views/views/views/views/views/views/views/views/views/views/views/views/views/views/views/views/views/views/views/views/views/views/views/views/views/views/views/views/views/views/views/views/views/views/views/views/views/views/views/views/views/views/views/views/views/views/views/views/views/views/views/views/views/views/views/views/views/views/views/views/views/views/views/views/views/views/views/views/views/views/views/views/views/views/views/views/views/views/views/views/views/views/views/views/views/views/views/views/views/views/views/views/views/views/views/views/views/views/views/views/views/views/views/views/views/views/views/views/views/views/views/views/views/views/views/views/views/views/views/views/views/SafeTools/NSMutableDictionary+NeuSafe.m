//
//  NSMutableDictionary+NeuSafe.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/15.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "NSMutableDictionary+NeuSafe.h"
#import "NSObject+NeuImpChangeTool.m"
@implementation NSMutableDictionary (NeuSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzlingMethod:@"removeObjectForKey"
                  sysClassStr:@"__NSDictionaryM"
              toSafeMethodStr:@"neu_removeObjectForKey:"
               targetClassStr:@"NSMutableDictionary"];
        
        [self swizzlingMethod:@"setObject:forKey:"
                  sysClassStr:@"__NSDictionaryM"
              toSafeMethodStr:@"neu_setObject:forKey:"
               targetClassStr:@"NSMutableDictionary"];
    });
}

/**
 *  崩溃情况：1.key = nil
 */
- (void)neu_removeObjectForKey:(id)key {
    if (!key) {
        return;
    }
    [self neu_removeObjectForKey:key];
}

/**
 *  崩溃情况：1.key = nil 2.obj = nil
 */
- (void)neu_setObject:(id)obj forKey:(id <NSCopying>)key {
    if (!obj) {
        return;
    }
    if (!key) {
        return;
    }
    [self neu_setObject:obj forKey:key];
}
@end
