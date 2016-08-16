//
//  NSObject+NeuImpChangeTool.h
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/15.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSObject (NeuImpChangeTool)
/**
 *  交换两个函数的实现指针
 *
 *  @param sysMethodStr   系统方法名
 *  @param sysClassStr    系统方法所在类名
 *  @param safeMethodStr  自定义hook方法名
 *  @param targetClassStr 自定义实现类名
 */
+ (void)swizzlingMethod:(NSString *)sysMethodStr
            sysClassStr:(NSString *)sysClassStr
        toSafeMethodStr:(NSString *)safeMethodStr
         targetClassStr:(NSString *)targetClassStr;
@end
