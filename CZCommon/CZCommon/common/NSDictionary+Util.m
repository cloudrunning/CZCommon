//
//  NSDictionary+Util.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "NSDictionary+Util.h"

@implementation NSDictionary (Util)
/** 有效字典判断*/
- (BOOL)isDictionary {
    
    return self !=nil && ![self isKindOfClass:[NSNull class]];
}
+ (BOOL)isDictionary:(NSDictionary *)dic {

    return [dic isDictionary];
}
@end
