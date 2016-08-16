//
//  TransationMainController.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/16.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "TransationMainController.h"
#import "TransationDetailController.h"
#import "TransitionPresentAnimation.h"
#import "TransitionDismissAnimation.h"
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
- (IBAction)modelAction:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TransationDetailController *detailVC = [story instantiateViewControllerWithIdentifier:@"TransationDetailController"];
    detailVC.transitioningDelegate = self;
    detailVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:detailVC animated:YES completion:nil];
}
#pragma mark ---- UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return [TransitionPresentAnimation new];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
     return [TransitionDismissAnimation new];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    
     return nil;
}

@end
