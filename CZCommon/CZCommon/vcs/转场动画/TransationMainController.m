//
//  TransationMainController.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/16.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "TransationMainController.h"
#import "PopAnimationController.h"
#import "RevealAnimController.h"
@interface TransationMainController () <UIViewControllerTransitioningDelegate>

@end

@implementation TransationMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"popAnim"]) {
        // 无需传参数 固注释掉
        // PopAnimationController *popVC = segue.destinationViewController;
        
    } else if ([segue.identifier isEqualToString:@"revealAnim"]) {
        // 无需传参数 固注释掉
        // RevealAnimController *revealVC = segue.destinationViewController;
    
    }
    

}
@end
