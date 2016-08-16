//
//  Person.h
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/10.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Dog;
@interface Person : NSObject

@property (nonatomic,assign) NSString *name;
@property (nonatomic,assign) unsigned int age;
@property (nonatomic,assign) double weight;
@property (nonatomic,strong) Dog *dog;
@property (nonatomic,strong) NSArray *books;


+ (void)run;
+ (void)study;
@end

@class Fish;
@interface Dog : NSObject

@property (nonatomic,assign) NSString *name;
@property (nonatomic,assign) NSString *price;
@property (nonatomic,strong)  Fish*  fish;

@end

@interface Fish : NSObject

@property (nonatomic,assign) NSString *name;
@property (nonatomic,assign) NSString *price;
@end

@interface Book : NSObject

@property (nonatomic,assign) NSString *name;
@property (nonatomic,assign) NSString *author;
@end



