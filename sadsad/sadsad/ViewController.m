//
//  ViewController.m
//  sadsad
//
//  Created by caozhen@neusoft on 16/8/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *tem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tem startAnimating];
    self.tem.hidesWhenStopped = YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.tem.hidden = YES;
    [self.tem stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
