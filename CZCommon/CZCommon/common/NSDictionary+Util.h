//
//  NSDictionary+Util.h
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Util)
/** 有效字典判断*/
- (BOOL)isDictionary;
+ (BOOL)isDictionary:(NSDictionary *)dic;
@end
