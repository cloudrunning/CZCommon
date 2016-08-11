//
//  RuntimeController.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/10.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "RuntimeController.h"
#import "Person.h"
#import <objc/runtime.h>
#import "NSString+runtimeAddProperty.h"
#import "NSObject+EnAndDecoder.h"
@interface RuntimeController ()

@end

@implementation RuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  1.0 方法的简单交换
 *  Mark:
        Method class_getClassMethod(Class cls , SEL name)   //获得某个类的类方法
        Method class_getInstanceMethod(Class cls , SEL name) //获得某个类的实例对象方法
        void method_exchangeImplementations(Method m1 , Method m2)  //交换两个方法的实现

 */
- (IBAction)methodExchangeAction:(id)sender {
    [Person run];
    [Person study];
    Method m1 = class_getClassMethod([Person class], @selector(run));
    
    Method m2 = class_getClassMethod([Person class], @selector(study));
    method_exchangeImplementations(m1, m2);
    [Person run];
    [Person study];
}
/**
 *  2.0 拦截系统方法
 */
- (IBAction)interceptSystemMethod:(id)sender {
}

/**
 *  3.0 类别中增加属性
 *  Mark:
    void objc_setAssociatedObject(id object , const void *key ,id value ,objc_AssociationPolicy policy)   // set方法
    id objc_getAssociatedObject(id object , const void *key)  //get方法
 */
- (IBAction)categotyAddPropertyAction:(id)sender {
    
    NSString *xiaoming = @"xiaoming";
    xiaoming.name = @"xiaoming";
    NSLog(@"xiaoming.name = %@",xiaoming.name);
}
/**
 *  4.1获取Person类所有成员变量的名字和类型
 
 */
- (IBAction)getAllPropertiesAndTypesOfPersonAction:(id)sender
{
    unsigned int outCont = 0;
    Ivar *ivars = class_copyIvarList([Person class], &outCont);
    for (int i = 0; i < outCont; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSLog(@"成员变量名：%s 成员变量类型：%s",name,type);
    }
    free(ivars);
}

/**
 *  4.2 获取所有属性重写归档接档方法
 
 */
- (IBAction)decodeAndEncodeAction:(id)sender {
    
    NSLog(@"详情见:NSObject+EnAndDecoder.h");
}

/**
 *  4.3获取所有属性进行字典转模型
 
 */
- (IBAction)translateDicToModel:(id)sender {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"personJSON" ofType:@"geojson"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",dict);
    
//    Person *person = [Person objectWithDict:dict];
}


@end
