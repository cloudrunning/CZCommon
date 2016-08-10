//
//  NSString+Util.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)
/** 判空*/
- (BOOL)isEmpty {
    
    return (self == nil||[self isKindOfClass:[NSNull class]]
        ||([self isKindOfClass:[NSString class]] && self.length == 0));
}
+ (BOOL)isEmpty:(NSString *)str {
    
    return [str isEmpty];
}
@end


#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Encrypt)
/** sha1加密*/
- (NSString *)sha1 {
    
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(CC_LONG) data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}
+ (NSString *)sha1:(NSString *)str {
    
    return [str sha1];
}

/** md5加密*/
- (NSString *)md5 {
    
    if (self == nil || [self length] == 0) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

+ (NSString *)md5:(NSString *)str{
    
    return [str md5];
}
@end