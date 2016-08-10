//
//  NSString+Util.h
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)
/** 判空*/
- (BOOL)isEmpty;
+ (BOOL)isEmpty:(NSString *)str;

@end


@interface NSString (Encrypt)
/** sha1加密*/
- (NSString *)sha1;
+ (NSString *)sha1:(NSString *)str;

/** md5加密*/
- (NSString *)md5;
+ (NSString *)md5:(NSString *)str;
@end