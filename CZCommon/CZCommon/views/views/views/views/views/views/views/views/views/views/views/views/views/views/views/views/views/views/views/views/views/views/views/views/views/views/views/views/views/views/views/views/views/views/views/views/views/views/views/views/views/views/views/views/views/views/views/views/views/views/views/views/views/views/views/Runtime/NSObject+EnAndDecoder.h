//
//  NSObject+EnAndDecoder.h
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/10.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (EnAndDecoder)
- (NSArray *)ignoreNames;
- (void)encode:(NSCoder *)aCoder;
- (void)decode:(NSCoder *)aDecoder;
@end


@interface NSObject (JSONExtention)
- (NSString *)arrayObjectClass;
+ (instancetype)objectWithDict:(NSDictionary *)dict;
@end