//
//  NSObject+NeuImpChangeTool.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/15.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "NSObject+NeuImpChangeTool.h"

@implementation NSObject (NeuImpChangeTool)

+ (void)swizzlingMethod:(NSString *)sysMethodStr
            sysClassStr:(NSString *)sysClassStr
        toSafeMethodStr:(NSString *)safeMethodStr
         targetClassStr:(NSString *)targetClassStr
{
    //获取系统方法IMP
    Method sysMethod = class_getInstanceMethod(NSClassFromString(sysClassStr), NSSelectorFromString(sysMethodStr));
    //自定义方法的IMP
    Method safeMethod = class_getClassMethod(NSClassFromString(targetClassStr), NSSelectorFromString(safeMethodStr));
    //IMP相互交换，方法的实现也就互相交换了
    method_exchangeImplementations(sysMethod, safeMethod);

}

@end
