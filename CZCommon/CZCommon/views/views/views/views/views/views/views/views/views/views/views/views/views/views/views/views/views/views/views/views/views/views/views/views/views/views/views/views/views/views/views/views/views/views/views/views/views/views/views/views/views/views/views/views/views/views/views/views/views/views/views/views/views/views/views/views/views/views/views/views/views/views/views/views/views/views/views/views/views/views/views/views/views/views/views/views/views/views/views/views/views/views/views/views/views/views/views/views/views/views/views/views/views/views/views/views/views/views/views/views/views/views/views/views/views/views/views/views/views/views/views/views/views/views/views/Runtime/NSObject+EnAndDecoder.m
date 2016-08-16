//
//  NSObject+EnAndDecoder.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/10.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "NSObject+EnAndDecoder.h"
#import <objc/runtime.h>
@implementation NSObject (EnAndDecoder)
/**
 *  不需要归解档的属性
 */
- (NSArray *)ignoreNames {
    return @[];
}
- (void)encode:(NSCoder *)aCoder {
    
    Class c = self.class;
    while (c && c !=[NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if (![self.ignoreNames containsObject:key]) continue;
            id value = [self valueForKey:key];
            [aCoder encodeObject:value forKey:key];
        }
        free(ivars);
        
        c = [c superclass];
    }
}
- (void)decode:(NSCoder *)aDecoder {
    
    Class c = self.class;
    while (c && c !=[NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if (![self.ignoreNames containsObject:key]) continue;
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
        
        c = [c superclass];
    }

}

@end



@implementation NSObject (JSONExtention)

- (void)setDict:(NSDictionary *)dict {
    
    Class c = self.class;
    
    while (c && c != [NSObject class]) {
        unsigned int outCount;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            //去掉下划线
            key = [key substringFromIndex:1];
            id value = dict[key];
            if (value == nil) continue;
            
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            //判断是否为对象
            NSRange range = [type rangeOfString:@""];
            if (range.location != NSNotFound) {
                //去掉@""
                type = [type substringWithRange:NSMakeRange(2, type.length -3)];
                
                if (![type hasPrefix:@"NS"]) {
                    //嵌套解析
                    Class class = NSClassFromString(type);
                    value = [class objectWithDict:value];
                }else if([type isEqualToString:@"NSArray"]){
                    //解析数组
                    NSArray *array = value;
                    NSMutableArray *mArray = [NSMutableArray array];
                    
                    //数组类型
                    id class;
                    if ([self respondsToSelector:@selector(arrayObjectClass)]) {
                        class = NSClassFromString([self arrayObjectClass]);
                    }
                    
                    for (int i = 0; i < array.count; i++) {
                        [mArray addObject:[class objectWithDict:array[i]]];
                    }
                    value = mArray;
                
                }
                
            }
            
            [self setValue:value forKeyPath:key];
        }
        free(ivars);
        c = [c superclass];
    }

}

+ (instancetype)objectWithDict:(NSDictionary *)dict {
    NSObject *obj = [[self alloc]init];
    [obj setDict:dict];
    return obj;
}
@end













