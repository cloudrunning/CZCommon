//
//  NSString+runtimeAddProperty.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/10.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <objc/runtime.h>
char nameKey;
#import "NSString+runtimeAddProperty.h"
@implementation NSString (runtimeAddProperty)

/*Mark:
    object:给哪个对象设置属性
    key:属性别名，最终通过该key存取值(key 可以是任何类型：double、int 等，建议用char 可以节省字节)
    value:给属性设置的值
    objc_setAssociatedObject(id object , const void *key ,id value ,objc_AssociationPolicy value)
 */
- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)name {
    return objc_getAssociatedObject(self, &nameKey);
}


@end
