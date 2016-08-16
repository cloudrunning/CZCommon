//
//  NSArray+NeuSafe.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/15.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "NSArray+NeuSafe.h"
#import "NSObject+NeuImpChangeTool.h"


/**
 *  make:NSArray 崩溃一般有三种情况：
    1.objectAtIndex  下标越界
        reason: '*** -[__NSArrayI objectAtIndex:]: index 3 beyond bounds [0 .. 2]
    2.arrayByAddingObject  追加nil
        reason: '*** -[NSArray arrayByAddingObject:]: object cannot be nil'
    3.arrayWithObject 添加nil
        运行代码
            NSArray * testArray = [NSArray arrayWithObject:nil];
        崩溃日志
            reason: '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[0]
 */
 
 
@implementation NSArray (NeuSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzlingMethod:@"objectAtIndex:" sysClassStr:@"__NSArrayI" toSafeMethodStr:@"neu_objectAtIndex:" targetClassStr:@"NSArray"];
        
        [self swizzlingMethod:@"initWithObjects:count:" sysClassStr:@"__NSPlaceholderArray" toSafeMethodStr:@"initWithObjects_neu:" targetClassStr:@"NSArray"];
        
        [self swizzlingMethod:@"arrayByAddingObject:" sysClassStr:@"__NSArrayI" toSafeMethodStr:@"neu_arrayByAddingObject:" targetClassStr:@"NSArray"];
    });
}


- (id)neu_objectAtIndex:(NSUInteger)index {
    
    if (index >= self.count) {
        return nil;
    }
    return [self neu_objectAtIndex:index];
}

- (NSArray *)neu_arrayByAddingObject:(id)anObject {

    if (!anObject) {
        return self;
    }
    return [self neu_arrayByAddingObject:anObject];
}


- (instancetype)initWithObjects_neu:(id *)objects count:(NSUInteger)count
{
    
    NSUInteger newCount = 0;
    for (int i = 0; i<count; i++) {
        if (!objects[i]) {
            break;
        }
        newCount ++;
    }
    self = [self initWithObjects_neu:objects count:newCount];
    return self;
}


@end
