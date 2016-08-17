//
//  HSRevealAnimation.h
//  reveal
//
//  Created by caozhen@neusoft on 16/8/17.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSRevealAnimation : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic,assign) UINavigationControllerOperation operation;

@end
