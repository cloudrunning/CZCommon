//
//  PopAnimationController.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/17.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "PopAnimationController.h"
#import "PopAnimationDetailController.h"
#import "TransitionPresentAnimation.h"
#import "TransitionDismissAnimation.h"

@interface PopAnimationController () <UIViewControllerTransitioningDelegate>

@end

@implementation PopAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)modelAction:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PopAnimationDetailController *detailVC = [story instantiateViewControllerWithIdentifier:@"Pop"];
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
