//
//  HSRevealAnimation.m
//  reveal
//
//  Created by caozhen@neusoft on 16/8/17.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "HSRevealAnimation.h"
#import "RevealAnimController.h"
#import "RevealAnimDetailController.h"

@interface HSRevealAnimation () {
    NSUInteger _animationDuration;
    __weak id <UIViewControllerContextTransitioning> tempContext;
}

@end

@implementation HSRevealAnimation
- (instancetype)init
{
    self = [super init];
    if (self) {
        _animationDuration = 1.0;
        _operation = UINavigationControllerOperationPush;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return _animationDuration;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    if (_operation == UINavigationControllerOperationPush) {
        RevealAnimController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        RevealAnimDetailController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        [[transitionContext containerView] addSubview:toVC.view];
        tempContext = transitionContext;
        
        //加动画
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0.0, -10.0, 0.0), CATransform3DMakeScale(150.0, 150.0, 1.0))];
        animation.duration = _animationDuration;
        animation.delegate = self;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
        [fromVC.logo addAnimation:animation forKey:nil];
        [toVC.maskLayer addAnimation:animation forKey:nil];
        
        CABasicAnimation *fadeInAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeInAnim.fromValue = @(0.0);
        fadeInAnim.toValue   = @(1.0);
        fadeInAnim.duration = _animationDuration;
        [toVC.view.layer addAnimation:fadeInAnim forKey:nil];
        
    }else {
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [[transitionContext containerView]insertSubview:toView belowSubview:fromView];
        
        //加动画
        [UIView animateWithDuration:_animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (tempContext) {
        [tempContext completeTransition:[tempContext transitionWasCancelled]];
        
        RevealAnimController *fromVC = [tempContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        [fromVC.logo removeAllAnimations];
    }
    tempContext = nil;
}


@end




