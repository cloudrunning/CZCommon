//
//  TransitionPresentAnimation.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/16.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "TransitionPresentAnimation.h"
#import <POP.h>

@implementation TransitionPresentAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {

    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
     UIView *toView = [[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] view];
    toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIView *containerView = [transitionContext containerView];
    toView.center = CGPointMake(containerView.center.x, -containerView.center.y);
    [containerView addSubview:toView];
    
    //增加pop动画
    POPSpringAnimation *positionAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnim.toValue = @(containerView.center.y);
    positionAnim.springBounciness = 10;
    [positionAnim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    
    POPSpringAnimation *scaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnim.springBounciness = 20;
    scaleAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];
    [toView.layer pop_addAnimation:positionAnim forKey:@"postionAnimation"];
    [toView.layer pop_addAnimation:scaleAnim forKey:@"scaleAnimation"];
    
    
}
@end
