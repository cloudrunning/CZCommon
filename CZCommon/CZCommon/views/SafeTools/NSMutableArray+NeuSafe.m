//
//  NSMutableArray+NeuSafe.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/15.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "NSMutableArray+NeuSafe.h"
#import "NSObject+NeuImpChangeTool.m"
/**
 *  mark:可变数组崩溃的情况（增删改查含nil,取值数组越界）
 *
 *  [__NSPlaceholderArray initWithObjects:count:]
    [__NSArrayM insertObject:atIndex:]
    [__NSArrayM objectAtIndex:]
    [__NSArrayM removeObjectAtIndex:]
    [__NSArrayM replaceObjectAtIndex:withObject:]
    [NSMutableArray replaceObjectsInRange:withObjectsFromArray:]
 
 */
@implementation NSMutableArray (NeuSafe)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        [self swizzlingMethod:@"addObject:"
                  sysClassStr:@"__NSArrayM"
              toSafeMethodStr:@"neu_addObject"
               targetClassStr:@"NSMutableArray"];
        
        [self swizzlingMethod:@"insertObject:atIndex:" sysClassStr:@"__NSArrayM" toSafeMethodStr:@"neu_insertObject:atIndex:" targetClassStr:@"NSMutableArray"];
        
        [self swizzlingMethod:@"removeObjectAtIndex:" sysClassStr:@"__NSArrayM" toSafeMethodStr:@"neu_removeObjectAtIndex:" targetClassStr:@"NSMutableArray"];
        
        [self swizzlingMethod:@"replaceObjectAtIndex:withObject:" sysClassStr:@"__NSArrayM" toSafeMethodStr:@"neu_replaceObjectAtIndex:withObject:" targetClassStr:@"NSMutableArray"];
        
        [self swizzlingMethod:@"removeObjectsAtIndexes:" sysClassStr:@"NSMutableArray" toSafeMethodStr:@"neu_removeObjectsAtIndexes:" targetClassStr:@"NSMutableArray"];
        [self swizzlingMethod:@"removeObjectsInRange:" sysClassStr:@"NSMutableArray" toSafeMethodStr:@"neu_removeObjectsInRange:" targetClassStr:@"NSMutableArray"];
        
        [self swizzlingMethod:@"objectAtIndex:" sysClassStr:@"__NSArrayM" toSafeMethodStr:@"neu_objectAtIndex:" targetClassStr:@"NSMutableArray"];
        
    });
}
/**
 *  崩溃情况：1.anObject = nil
 */
- (void)neu_addObject:(id)anObject {
    
    if (!anObject) {
        return;
    }
    [self neu_addObject:anObject];
}

/**
 *  崩溃情况：1.index越界 2.anObject = nil
 */
- (void)neu_insertObject:(id)anObject atIndex:(NSUInteger)index {
    
    if (index > self.count) {
        return;
    }
    
    if (!anObject) {
        return;
    }
    
    [self neu_insertObject:anObject atIndex:index];
}

/**
 *  崩溃情况：1.index越界
 */
- (void)neu_removeObjectAtIndex:(NSUInteger)index {

    if (index >= self.count) {
        return;
    }
    return [self neu_removeObjectAtIndex:index];
}

/**
 *  崩溃情况：1.index越界 2.anObject = nil
 */
- (void)neu_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index >= self.count) {
        return;
    }
    
    if (!anObject) {
        return;
    }
    
    [self neu_replaceObjectAtIndex:index withObject:anObject];

}

/**
 *  崩溃情况：1.indexes 中含有越界index
 */
- (void)neu_removeObjectsAtIndexes:(NSIndexSet *)indexes {
    
    NSMutableIndexSet *mutableSet = [NSMutableIndexSet indexSet];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.count) {
            [mutableSet addIndex:idx];
        }
    }];
    [self neu_removeObjectsAtIndexes:mutableSet];
}

/**
 *  崩溃情况：range 超出[0,count)范围时
 */
- (void)neu_removeObjectsInRange:(NSRange)range {
    //range包含与[0,count)
    NSInteger maxIndexInRange = range.location + range.length - 1;
    if (maxIndexInRange < self.count) {
        [self neu_removeObjectsInRange:range];
        return;
    }
    //无交集
    if (range.location >= self.count) {
        return;
    }
    
    //有交集
    while (maxIndexInRange >= self.count) {
        maxIndexInRange --;
    }
    NSRange finalRange = NSMakeRange(range.location, maxIndexInRange - range.location + 1);
    [self neu_removeObjectsInRange:finalRange];

}

/**
 *  崩溃情况：index越界
 */
- (id)neu_objectAtIndex:(NSUInteger)index {
    
    if (index >= self.count) {
        return nil;
    }
    return [self neu_objectAtIndex:index];
}
@end
