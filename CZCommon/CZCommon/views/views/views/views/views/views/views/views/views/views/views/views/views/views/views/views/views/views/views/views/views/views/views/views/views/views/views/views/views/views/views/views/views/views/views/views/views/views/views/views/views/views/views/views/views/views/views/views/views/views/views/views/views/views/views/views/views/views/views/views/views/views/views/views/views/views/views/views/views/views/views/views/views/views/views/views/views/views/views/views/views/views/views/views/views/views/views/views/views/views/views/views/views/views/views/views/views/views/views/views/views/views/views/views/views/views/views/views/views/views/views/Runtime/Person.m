//
//  Person.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/10.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "Person.h"
#import "NSObject+EnAndDecoder.h"
@implementation Person
+ (void)run {
    NSLog(@"跑");
}

+ (void)study {
    NSLog(@"学习");
}

- (NSString *)arrayObjectClass{
    return  NSStringFromClass([Book class]);
}
@end


@implementation Dog


@end

@implementation Fish


@end

@implementation Book


@end