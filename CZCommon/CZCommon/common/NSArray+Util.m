//
//  NSArray+Util.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "NSArray+Util.h"

@implementation NSArray (Util)
/** 有效数组判断*/
- (BOOL)isArray {
    
    return self != nil && ![self isKindOfClass:[NSNull class]];
}
+ (BOOL)isArray:(NSArray *)array {
    
    return [array isArray];
}
@end
