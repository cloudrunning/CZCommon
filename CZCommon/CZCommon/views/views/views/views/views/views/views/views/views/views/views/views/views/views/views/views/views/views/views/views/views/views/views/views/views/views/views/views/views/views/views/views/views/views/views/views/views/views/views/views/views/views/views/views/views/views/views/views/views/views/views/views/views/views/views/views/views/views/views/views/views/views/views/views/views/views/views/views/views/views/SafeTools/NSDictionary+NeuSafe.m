//
//  NSDictionary+NeuSafe.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/15.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "NSDictionary+NeuSafe.h"
#import "NSObject+NeuImpChangeTool.h"
/**
    make:NSDictionary 一般在初始化时候崩溃,（初始化有空值）
 *      [__NSPlaceholderDictionary initWithObjects:forKeys:count:]
 */
@implementation NSDictionary (NeuSafe)
+ (void)load {
    
    [self swizzlingMethod:@"initWithObjects:forKeys:count:" sysClassStr:@"__NSPlaceholderDictionary" toSafeMethodStr:@"initWithObjects_neu:forKeys:count:" targetClassStr:@"NSDictionary"];
    
}


- (instancetype)initWithObjects_neu:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)cnt {
    
    NSUInteger newCount = 0;
    for (int i = 0; i<cnt; i++) {
        if (!(keys[i]&&objects[i])) {
            break;
        }
        newCount ++;
    }
    self = [self initWithObjects_neu:objects forKeys:keys count:newCount];
    return self;
    
}
@end
