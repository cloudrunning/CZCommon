//
//  TransitionDismissAnimation.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/16.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "TransitionDismissAnimation.h"
#import <POP.h>
@implementation TransitionDismissAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.5f;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *fromView = [[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] view];
    
    // 加动画
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    offscreenAnimation.toValue = @(-fromView.layer.position.y);
    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    [fromView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];

}
@end
